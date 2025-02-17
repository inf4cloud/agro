package Model;

public class EnderecoPessoa {
  private int idenderecoPessoa;
  private Pessoa pessoa;
  private Endereco endereco;
  private String Numero;
  private String Complemento;
public int getIdenderecoPessoa() {
	return idenderecoPessoa;
}
public void setIdenderecoPessoa(int idenderecoPessoa) {
	this.idenderecoPessoa = idenderecoPessoa;
}
public Pessoa getPessoa() {
	return pessoa;
}
public void setPessoa(Pessoa pessoa) {
	this.pessoa = pessoa;
}
public Endereco getEndereco() {
	return endereco;
}
public void setEndereco(Endereco endereco) {
	this.endereco = endereco;
}
public String getNumero() {
	return Numero;
}
public void setNumero(String numero) {
	Numero = numero;
}
public String getComplemento() {
	return Complemento;
}
public void setComplemento(String complemento) {
	Complemento = complemento;
}
  

  
}
