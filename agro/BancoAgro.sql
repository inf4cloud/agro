create table despesascusto(

	iddespesascusto serial primary key,
	despesascusto varchar(50) not null,
	unidadedespesascustos varchar(2) not null,
	valordespesascustos decimal(10,2) not  null,
	tipodespesascustos varchar(20) not null
	
	)

/*Tabela Classificacao*/
create	table	classificacao(

	idclassificao serial primarykey,
	despesascusto varchar (50)not null
	)
/*Tabela endereco*/
create table endereco(
 	idendereco serial primary key,
	Endereco varchar(50) not null,
	Numero varchar(50) not null,
	Complemento varchar(50) not null,
	Cep varchar(15) not null,
    Bairro varchar(50) not null,
	Cidade varchar(50) not null,
	Estado varchar(30) not null,
	Pais varchar(50) not null,
    localizacaogeografica varchar(50) not null
)
/*Tabela Pessoa*/
create table pessoa(
	idpessoa serial primary key,
	nomepessoa varchar(50) not null,
	usuariopessoa varchar(50) not null,
	senhapessoa varchar(50) not null,
	nivelpessoa varchar(20) not null,
	situacaopessoa BOOLEAN,
	emailpessoa varchar(50) not null unique,
	telefonepessoa varchar(25) not null,
	idendereco int ,
	CONSTRAINT fk_endereco FOREIGN KEY (idendereco) REFERENCES endereco (idendereco)
);
/*tabela pessoa fisica*/
CREATE TABLE pessoafisica (
  cpfPf varchar(50) not null unique,
  dataNascimentoPf date not null
) INHERITS (pessoa);

/*tabela pessoa cnpjs*/
CREATE TABLE pessoacnpj (
 cnpjPessoaCnpj varchar(50) not null unique,
 razaoSocialPessoaCnpj varchar(50) not null unique,
inscricaoEstadualPessoaCnpj varchar(50) not null unique
) INHERITS (pessoa);
/*tabela pessoa cnpjs*/
CREATE TABLE parceiro (
siteparceiro varchar(50) not null unique
 
) INHERITS (pessoacnpj);
select*from parceiro