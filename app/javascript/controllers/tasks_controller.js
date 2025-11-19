// Importa a classe Controller do framework Stimulus para criar controladores interativos
import { Controller } from "@hotwired/stimulus"

// Define e exporta um controlador Stimulus para gerenciar tarefas
export default class extends Controller {
  // Define um valor configurável chamado 'debounce' que pode ser passado via atributo data-tasks-debounce-value
  // Por padrão, o valor é 300 milissegundos (0.3 segundos)
  static values = { debounce: { type: Number, default: 300 } }

  // Inicializa a propriedade timeout como null para armazenar referência ao temporizador
  timeout = null

  // Método principal que é chamado para executar uma ação com debounce
  perform() {
    // Cancela qualquer timeout anterior ainda pendente para evitar múltiplas submissões
    clearTimeout(this.timeout)

    // Cria um novo timeout que aguarda o tempo definido em debounceValue antes de executar
    this.timeout = setTimeout(() => {
      // Submete o formulário associado ao elemento do controlador após o delay
      this.element.requestSubmit()
    }, this.debounceValue)
  }

  // Método do ciclo de vida do Stimulus, chamado quando o controlador é desconectado do DOM
  disconnect() {
    // Limpa o timeout para evitar vazamento de memória e submissões indesejadas
    clearTimeout(this.timeout)
  }
}
