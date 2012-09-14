PadrinoBoilerplate.controllers :pages do
  get :index, :map => '/', :cache => true do
    render 'pages/index'
  end
end
