# Comparando Detectores de Cantos em MATLAB

Este projeto tem por objetivo realizar uma comparação entre os algoritmos detectores de cantos, presentes no MATLAB, em relação ao número de correspondências que estes podem produzir em um par de imagens estéreo.

## Introdução

A **visão estéreo** é uma das áreas de processamento digital de imagens que busca reconstruir cena, em três dimensões, a partir de um conjunto de imagens obtidas da mesma. Um dos requisitos necessários para que a reconstrução de uma cena em três dimensões seja satisfatória é que o algoritmo de reconstrução da cena seja capaz de reconhecer pontos comuns, que pertençam a um mesmo objeto, dentro das imagens de entrada. Esse processo de associação entre tais pontos é chamado de correspondência [1]. Em geral, os algoritmos de correspondência utilizam os cantos dos objetos presentes nas imagens analisadas como referência para tal processo.

Uma vez que, na literatura, existem vários algoritmos detectores de cantos, o detector de cantos escolhido pode impactar diretamente na qualidade das correspondências entre um conjunto de imagens estéreo. Desse modo, este projeto teve como objetivo realizar uma comparação entre os principais algoritmos de detecção de cantos, verificando o impacto dos mesmos na produção de correspondências entre pares de imagens estéreo.

## Materiais Utilizados

- [**MATLAB R2017b**](https://www.mathworks.com/products/matlab.html) ou posterior, versão x64.
- Um conjunto de imagens disponíveis na base de dados de [Middlebury](http://vision.middlebury.edu/stereo/data/) para os testes.

## Informações Adicionais

Como isso é um trabalho em progresso, provavelmente muita coisa aqui vai mudar futuramente. Fique atento!

## Licença de Uso

Os códigos disponibilizados aqui estão sob a licença do MIT, versão 3.0 (veja o arquivo `LICENSE` em anexo para mais detalhes). Dúvidas sobre este projeto podem ser enviadas para o meu e-mail: carloswdecarvalho@outlook.com.

## Referências

[1] Hartley, R; Zisserman, A. "Multiple View Geometry in Computer Vision". Cambridge University Press, 2003.