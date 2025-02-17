package Model;

public class AlimentoClassificacao {
	private int idAlimentoClassificacao;
	private Alimento alimento;
	private Classificacao classificacao;
	public int getIdAlimentoClassificacao() {
		return idAlimentoClassificacao;
	}
	public void setIdAlimentoClassificacao(int idAlimentoClassificacao) {
		this.idAlimentoClassificacao = idAlimentoClassificacao;
	}
	public Alimento getAlimento() {
		return alimento;
	}
	public void setAlimento(Alimento alimento) {
		this.alimento = alimento;
	}
	public Classificacao getClassificacao() {
		return classificacao;
	}
	public void setClassificacao(Classificacao classificacao) {
		this.classificacao = classificacao;
	}
 
}
