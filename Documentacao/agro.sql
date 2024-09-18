-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 29-Dez-2021 às 01:13
-- Versão do servidor: 10.4.21-MariaDB
-- versão do PHP: 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `agro`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `alimento`
--

CREATE TABLE `alimento` (
  `idalimento` int(11) NOT NULL,
  `fruta` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `variedade` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `alimentoclassificacao`
--

CREATE TABLE `alimentoclassificacao` (
  `idalimentoclassificao` int(11) NOT NULL,
  `idalimento` int(11) NOT NULL,
  `idclassificacao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `area`
--

CREATE TABLE `area` (
  `idarea` int(11) NOT NULL,
  `area` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `idendereco` int(11) NOT NULL,
  `quantidadeplantes` int(11) NOT NULL,
  `variedade` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `areaalimento`
--

CREATE TABLE `areaalimento` (
  `idareaalimento` int(11) NOT NULL,
  `idarea` int(11) NOT NULL,
  `idalimento` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `classificacao`
--

CREATE TABLE `classificacao` (
  `idclassificacao` int(11) NOT NULL,
  `classificacao` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `classificacao`
--

INSERT INTO `classificacao` (`idclassificacao`, `classificacao`) VALUES
(34, '40'),
(36, '45');

-- --------------------------------------------------------

--
-- Estrutura da tabela `endereco`
--

CREATE TABLE `endereco` (
  `idendereco` int(11) NOT NULL,
  `endereco` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `cep` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `localizacageografica` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `complemento` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `cidade` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `pais` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `parceiros`
--

CREATE TABLE `parceiros` (
  `idparceiro` int(11) NOT NULL,
  `parceiro` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `id_usuarios` int(11) NOT NULL,
  `idendereco` int(11) NOT NULL,
  `variedade` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuarios` int(11) NOT NULL,
  `nome_usuarios` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `senha_usuarios` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `nivel_usuarios` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `usuarios`
--

INSERT INTO `usuarios` (`id_usuarios`, `nome_usuarios`, `senha_usuarios`, `nivel_usuarios`) VALUES
(1, 'luciano', '1234', 1),
(2, 'siqueira', '1234', 2);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `alimento`
--
ALTER TABLE `alimento`
  ADD PRIMARY KEY (`idalimento`);

--
-- Índices para tabela `alimentoclassificacao`
--
ALTER TABLE `alimentoclassificacao`
  ADD PRIMARY KEY (`idalimentoclassificao`),
  ADD KEY `idclassificacao` (`idclassificacao`),
  ADD KEY `idalimento` (`idalimento`);

--
-- Índices para tabela `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`idarea`);

--
-- Índices para tabela `areaalimento`
--
ALTER TABLE `areaalimento`
  ADD PRIMARY KEY (`idareaalimento`),
  ADD KEY `idarea` (`idarea`),
  ADD KEY `idalimento` (`idalimento`);

--
-- Índices para tabela `classificacao`
--
ALTER TABLE `classificacao`
  ADD PRIMARY KEY (`idclassificacao`);

--
-- Índices para tabela `endereco`
--
ALTER TABLE `endereco`
  ADD PRIMARY KEY (`idendereco`);

--
-- Índices para tabela `parceiros`
--
ALTER TABLE `parceiros`
  ADD PRIMARY KEY (`idparceiro`),
  ADD KEY `id_usuarios` (`id_usuarios`),
  ADD KEY `idendereco` (`idendereco`);

--
-- Índices para tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuarios`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `alimento`
--
ALTER TABLE `alimento`
  MODIFY `idalimento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `alimentoclassificacao`
--
ALTER TABLE `alimentoclassificacao`
  MODIFY `idalimentoclassificao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `area`
--
ALTER TABLE `area`
  MODIFY `idarea` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `areaalimento`
--
ALTER TABLE `areaalimento`
  MODIFY `idareaalimento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `classificacao`
--
ALTER TABLE `classificacao`
  MODIFY `idclassificacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de tabela `endereco`
--
ALTER TABLE `endereco`
  MODIFY `idendereco` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `parceiros`
--
ALTER TABLE `parceiros`
  MODIFY `idparceiro` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuarios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `alimentoclassificacao`
--
ALTER TABLE `alimentoclassificacao`
  ADD CONSTRAINT `alimentoclassificacao_ibfk_1` FOREIGN KEY (`idclassificacao`) REFERENCES `classificacao` (`idclassificacao`),
  ADD CONSTRAINT `alimentoclassificacao_ibfk_2` FOREIGN KEY (`idalimento`) REFERENCES `alimento` (`idalimento`);

--
-- Limitadores para a tabela `areaalimento`
--
ALTER TABLE `areaalimento`
  ADD CONSTRAINT `areaalimento_ibfk_1` FOREIGN KEY (`idarea`) REFERENCES `area` (`idarea`),
  ADD CONSTRAINT `areaalimento_ibfk_2` FOREIGN KEY (`idalimento`) REFERENCES `alimento` (`idalimento`);

--
-- Limitadores para a tabela `parceiros`
--
ALTER TABLE `parceiros`
  ADD CONSTRAINT `parceiros_ibfk_1` FOREIGN KEY (`id_usuarios`) REFERENCES `usuarios` (`id_usuarios`),
  ADD CONSTRAINT `parceiros_ibfk_2` FOREIGN KEY (`idendereco`) REFERENCES `endereco` (`idendereco`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
