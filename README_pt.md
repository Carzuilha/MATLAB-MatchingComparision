# Comparando Detectores de Cantos em MATLAB

Este projeto tem por objetivo realizar uma comparação entre os algoritmos detectores de cantos, presentes no MATLAB, em relação ao número de correspondências que estes podem produzir em um par de imagens estéreo.

## Introdução

Um **mapa de disparidades** é uma representação gráfica da profundidade de elementos que estão presentes em uma cena. Os mapas de disparidade costumam ser muito utilizados na área de visão estéreo, em que tenta-se reproduzir computacionalmente aspectos da visão humana. Basicamente, a geração de um mapa de disparidades envolve até 3 (três) etapas:

 - A **calibração**, que ao avaliar características das câmeras de um sistema de visão estéreo, busca parâmetros importantes à geração de um mapa de disparidades;
 - A **retificação**, em que os parâmetros obtidos na etapa anterior são utilizados como referência no processo de captura (e posteriormente ajuste) das imagens de uma cena;
 - A **correspondência**, que parte das imagens obtidas pelo processo de retificação para gerar o mapa de disparidades.

Embora existam três etapas básicas, a primeira demanda tempo, o que pode impedir a utilização de sistemas de visão estéreo em ambientes reais. Por isso, há muitos estudos sobre como modelar sistemas de visão estéreo sem dependência de calibração [[1](https://www.researchgate.net/publication/220692096_Introductory_techniques_for_3-D_computer_vision)]. Uma das maneiras de se fazer isso é calculando um dos elementos-chave da etapa de calibração (conhecido como **matriz fundamental** [[2](https://www.cambridge.org/core/books/multiple-view-geometry-in-computer-vision/0B6F289C78B2B23F596CAA76D3D43F7A)]) utilizando apenas a geometria da cena a ser analisada. É o que este projeto faz. 

## Materiais Utilizados

- [**MATLAB R2017b**](https://www.mathworks.com/products/matlab.html) ou posterior, versão x64.
- Um conjunto de imagens disponíveis na base de dados de [Middlebury](http://vision.middlebury.edu/stereo/data/) para os testes.

## Informações Adicionais

Como isso é um trabalho em progresso, provavelmente muita coisa aqui vai mudar futuramente. Fique atento!

## Licença de Uso

Os códigos disponibilizados aqui estão sob a licença do MIT, versão 3.0 (veja o arquivo `LICENSE` em anexo para mais detalhes). Dúvidas sobre este projeto podem ser enviadas para o meu e-mail: carloswdecarvalho@outlook.com.

## Referências

[1] Hartley, R; Zisserman, A. "Multiple View Geometry in Computer Vision". Cambridge University Press, 2003.