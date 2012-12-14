module Padrino
  module Rendering
    module InstanceMethods
    private
      # Override render to store the current template being rendered so we can refer to it in the view
      # This works with Padrino >= 0.9.10
      def render(engine, data=nil, options={}, locals={}, &block)
        # If engine is a hash then render data converted to json
        content_type(:json, :charset => 'utf-8') and return engine.to_json if engine.is_a?(Hash) || engine.is_a?(Array)

        # If engine is nil, ignore engine parameter and shift up all arguments
        # render nil, "index", { :layout => true }, { :localvar => "foo" }
        engine, data, options = data, options, locals if engine.nil? && data

        # Data is a hash of options when no engine isn't explicit
        # render "index", { :layout => true }, { :localvar => "foo" }
        # Data is options, and options is locals in this case
        data, options, locals = nil, data, options if data.is_a?(Hash)

        # If data is unassigned then this is a likely a template to be resolved
        # This means that no engine was explicitly defined
        data, engine = *resolve_template(engine, options.dup) if data.nil?

        # PATCH: Store the current template being rendered
        # This method will also get executed for partials and stuff
        # so we just need to store it the first time we're called
        @_template ||= data

        # Setup root
        root = settings.respond_to?(:root) ? settings.root : ""

        # Use @layout if it exists
        options[:layout] = @layout if options[:layout].nil? || options[:layout] == true

        # Resolve layouts similar to in Rails
        if options[:layout].nil? && !settings.templates.has_key?(:layout)
          layout_path, layout_engine = *resolved_layout
          options[:layout] = layout_path || false # We need to force layout false so sinatra don't try to render it
          options[:layout] = false unless layout_engine == engine # TODO allow different layout engine
          options[:layout_engine] = layout_engine || engine if options[:layout]
        elsif options[:layout].present?
          options[:layout] = settings.fetch_layout_path(options[:layout] || @layout)
        end

        # Cleanup the template
        @current_engine, engine_was = engine, @current_engine
        @_out_buf,  _buf_was = "", @_out_buf

        # Pass arguments to Sinatra render method
        super(engine, data, options.dup, locals, &block)
      ensure
        @current_engine = engine_was
        @_out_buf = _buf_was
      end
    end
  end
end
