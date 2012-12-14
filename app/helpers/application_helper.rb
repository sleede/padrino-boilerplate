# encoding: utf-8

PadrinoBoilerplate.helpers do
  def dom_id(object)
    "#{object.class.to_s.downcase}_#{object.id.to_s}"
  end

  # see lib/current_controller_and_action.rb for more on why this works
  # (and also why this is kind of a kludge)
  def current_controller_and_action
    @current_controller_and_action ||= begin
      act, clr = @_template.to_s.sub(%r!^/!, "").split("/").reverse
      clr ||= "app"
      [clr, act]
    end
  end
  
  def current_controller; current_controller_and_action[0]; end
  def current_action;     current_controller_and_action[1]; end
end
