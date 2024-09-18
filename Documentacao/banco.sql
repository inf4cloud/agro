/*classificaçao*/
CREATE TABLE classificacao (
    idclassificacao int PRIMARY KEY AUTO_INCREMENT,
    classificacao VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*alimento*/
CREATE TABLE alimento (
    idalimento int PRIMARY KEY AUTO_INCREMENT,
    fruta VARCHAR(50) NOT NULL,
    variedade VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*alimentoclassificacao*/

CREATE TABLE alimentoclassificacao (
    idalimentoclassificao int PRIMARY KEY AUTO_INCREMENT,
  	idalimento int not null,
    idclassificacao int not null,
    FOREIGN KEY (idclassificacao) REFERENCES classificacao(idclassificacao),
    FOREIGN KEY (idalimento) REFERENCES alimento(idalimento)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

 /*endereco*/
CREATE TABLE endereco (
    idendereco int PRIMARY KEY AUTO_INCREMENT,
    endereco VARCHAR(50) NOT NULL,
    cep int not null,
    numero int not null,
    localizacageografica VARCHAR(50) NOT NULL,
    complemento VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*area*/
CREATE TABLE area (
    idarea int PRIMARY KEY AUTO_INCREMENT,
    area VARCHAR(50) NOT NULL,
    idendereco int not null,
    quantidadeplantes int not null,
    variedade VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*area_alimento*/
CREATE TABLE areaalimento (
    idareaalimento int PRIMARY KEY AUTO_INCREMENT,
    idarea int not null,
    idalimento int not null,
   
    FOREIGN KEY (idarea) REFERENCES area(idarea),
    FOREIGN KEY (idalimento) REFERENCES alimento(idalimento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*usuarios*/
	CREATE TABLE usuarios (
    idusuarios int PRIMARY KEY AUTO_INCREMENT,
    nomeusuarios VARCHAR(50) NOT NULL,
    senhausuarios varchar(50) not null,
    nivelusuarios int not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*parceiros*/
CREATE TABLE parceiros (
    idparceiro int PRIMARY KEY AUTO_INCREMENT,
    parceiro VARCHAR(50) NOT NULL,
    idusuarios int not null,
    idendereco int not null,
    variedade VARCHAR(50) NOT NULL,
    FOREIGN KEY (idusuarios) REFERENCES usuarios(idusuarios),
    FOREIGN KEY (idendereco) REFERENCES endereco(idendereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
