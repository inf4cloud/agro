
/* Classificação*/

// Abertura de atualizaçao da Modal
function abrirModalAtualizacao(id, classificacao) {
    $('#atualizacaoId').val(id);
    $('#atualizacaoClassificacao').val(classificacao);
    $('#modalAtualizacao').modal('show');
}

 // Função para abrir o modal de confirmação de exclusão
 function abrirModalExclusao(id, classificacao) {
    $('#exclusaoId').val(id);
   $('#exclusaoClassificacao').val(classificacao);
    $('#modalExclusao').modal('show');
  
}

 // Função para salvar a nova classificação
 function salvarClassificacao() {
    var classificacao = $('#classificacao').val();

    if (classificacao.trim() === '') {
        alert('Por favor, preencha a classificação.');
        return;
    }

    // Envia os dados da nova classificação para o servidor
    $.ajax({
        url: '/agro/ClassificacaoServlet',
        method: 'POST',
        data: {
            classificacao: classificacao
        },
        success: function(response) {
            alert(response.message)
            $('#modalCadastro').modal('hide');
            classificacao = $('#classificacao').val("")// Fecha o modal após salvar
            carregarClassificacoes(); // Recarrega as classificações para atualizar a tabela
        },
        error: function(xhr) {
            alert('Erro ao cadastrar classificação: ' + xhr.responseJSON.error);
        }
    });
}

//Atualizar Classificação

function atualizarClassificacao() {
    var id = $('#atualizacaoId').val();
    var classificacao = $('#atualizacaoClassificacao').val();
    var acao = $('#acao').val();

    if (classificacao.trim() === '') {
        alert('Por favor, preencha a classificação.');
        return;
    }

    // Log para verificar os dados que estão sendo enviados
    console.log('Enviando dados:', { id: id, classificacao: classificacao});

    // Envia os dados atualizados para o servidor usando PUT
    $.ajax({
        url: '/agro/ClassificacaoServlet',
        method: 'POST',
       
        data: {
            id: id,
            classificacao: classificacao,
        },
        success: function(response) {
            alert(response.message);
            $('#modalAtualizacao').modal('hide'); // Fecha o modal após atualizar
            carregarClassificacoes(); // Recarrega as classificações para atualizar a tabela
        },
        error: function(xhr) {
            console.error('Erro ao atualizar classificação:', xhr.responseText);
            alert('Erro ao atualizar classificação: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Erro desconhecido'));
        }
    });
}

 // Função para excluir a classificação
 function excluirClassificacao() {
    var id= $('#exclusaoId').val();
    var acao= "Delete"; 
    console.log(acao);
    $.ajax({
        url: '/agro/ClassificacaoServlet',
        method: 'POST',
       
        data: {
            id: id,
            acao: acao,
        },
        success: function(response) {
            alert(response.message);
            $('#modalExclusao').modal('hide'); // Fecha o modal após atualizar
            carregarClassificacoes(); // Recarrega as classificações para atualizar a tabela
        },
        error: function(xhr) {
            console.error('Erro ao atualizar classificação:', xhr.responseText);
            alert('Erro ao atualizar classificação: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Erro desconhecido'));
        }
    });
   
}
