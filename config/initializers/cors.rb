# frozen_string_literal: true

# Configuração do CORS (Cross-Origin Resource Sharing)
# Permite que sua aplicação Rails responda a requisições de diferentes origens

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Define quais origens podem acessar sua API
    # Em desenvolvimento, permite localhost em várias portas
    origins 'localhost:3000', '127.0.0.1:3000', 'localhost:5173', '127.0.0.1:5173'

    # Define quais recursos podem ser acessados
    resource '*',
      headers: :any, # Permite qualquer header
      methods: [:get, :post, :put, :patch, :delete, :options, :head], # Métodos HTTP permitidos
      credentials: true, # Permite envio de cookies e credenciais
      expose: ['Authorization'] # Headers que o navegador pode acessar
  end

  # Para produção, você deve especificar apenas os domínios necessários:
  # allow do
  #   origins 'https://seu-dominio.com', 'https://www.seu-dominio.com'
  #
  #   resource '*',
  #     headers: :any,
  #     methods: [:get, :post, :put, :patch, :delete, :options, :head],
  #     credentials: true
  # end
end
