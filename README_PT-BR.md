# Godot - TBP_GrassPath2D

- Desenvolvido e testado na Godot 3.2
- [English documentation](README.md)
- Testado com GLES2 e GLES3 (PC e Android)
- FPS varia bastante de acordo com a configuração do intervalo entre as folhas e o parâmetro "maxProcess" que é o número máximo de processos de física para o segmento de grama.

Gerador de grama interativa através de um Path2D(Curve).

### Parâmetros do Plugin
------
CUIDADO!!!
interval: esse parâmetro se menor que 15 pode perder consideravelmente a performance em conjunto com o parâmetro "interactive" se habilitado.

Para uma melhor performance, aumente o valor de "interval" que é o intervalo entre as folhas, e ajuste o limite dos processos para a física "maxProcess"
------
- ```interval```: Espaço entre as folhas
- ```interactive```: Se habilitado, interage com os objetos no grupo "groupInteractive"
- ```maxProcess```: Máximo de processos para a física das folhas que interagem ao mesmo tempo


- ```colorGrass```: Array de cores para as gramas - As texturas informadas em "grassTextures" precisam ser de cor branca	
- ```blur_samples```: Amostras para o blur
- ```blur_strength```: Força do blur, sendo de 0 à 1
- ```colorTerrain```: Cor do terreno, se ele for gerado
- ```generateTerrain```: Gera um terreno StaticBody com colisão
- ```maxHeightTerrain```: Altura máxima em pixels para o terreno gerado
- ```interactiveArea```: Uma largura em pixel para a área da folha interagir com o objeto
- ```followAngle```: Se as folhas devem seguir a rotação da curva do terreno
- ```heightGrass```: Altura da grama
- ```randomGrassMin```: Range mínimo para randomizar a rotação da folha
- ```randomGrassMax```: Range máximo para randomizar a rotação da folha
- ```windForce```: Força para o vento
- ```windDirection```: Direção do vento, sendo -1 para a esquerda, e 1 para a direita
- ```grassZIndex```: Indice para o Z Index das folhas
- ```grassYOffset```: Offset em Y para as folhas
- ```maxLeafRotateDegree```: Grau(º) máximo para a rotação das folhas
- ```grassTextures```: Array que será randomizado entre as folhas
- ```groupInteractive```: Array de Strings com o nome do grupo que a folha deve interagir, esse mesmo grupo deve estar no objeto

----------

### Demonstração (PT-BR)
- https://www.youtube.com/watch?v=6wFHC3af164

[![Demonstração](https://img.youtube.com/vi/6wFHC3af164/0.jpg)](https://www.youtube.com/watch?v=6wFHC3af164)

----------

##### Exemplo
- No projeto exemplo, mostro como utilizar o plugin, para movimentar o "player" no PC, use as setas, e o espaço para pular. 
- É possível também executar no Android, basta clicar e arrastar para movimentar o "player", e com o analógico pressionado toque com um segundo dedo para pular.

----------

##### Configurar o Addon
- Faça download do diretório [addons/TBP_GrassPath2D](addons/TBP_GrassPath2D)
- Coloque na pasta "addons" do seu projeto
- Acesse as Configurações do Projeto > Plugin e habilite o plugin "TBP_GrassPath2D"

----------

##### AnimationPlayer

Você pode usar um AnimationPlayer ou via GDScript para mudar alguns parâmetros em tempo de execução, por enquanto, é possível alterar os seguintes parâmentros:

- heightGrass
- windDirection
- windForce

----------

### ...
Vai utilizar esse código de forma comercial? Fique tranquilo pode usar de forma livre e sem precisar mencionar nada, claro que vou ficar contente se pelo menos lembrar da ajuda e compartilhar com os amigos, rs. Caso sinta no coração, considere me pagar um cafezinho :heart: -> https://ko-fi.com/thsbruno

