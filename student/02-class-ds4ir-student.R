# ---
#   title: "DS4IR"
# subtitle: "Processamento de Dados"
# author: 
#   - Professor Davi Moreira
# - Professor Rafael Magalhães
# date: "`r format(Sys.time(), '%d-%m-%Y')`"
# output: 
#   revealjs::revealjs_presentation:
#   theme: simple
# highlight: haddock
# transition: slide
# center: true
# css: stylesheet.css
# reveal_options:
#   controls: false  # Desativar botões de navegação no slide
# mouseWheel: true # Passar slides com o mous e
# ---
  
#   ## Motivação
#   
#   - Uma organização internacional (OI) tem o interesse de desenvolver projetos de promoção 
# de direitos humanos em diferentes regiões do globo. 
# - Sua grande preocupação é cuidar para que desde o início a formulação dos projetos considere
# caracteríticas regionais relacionadas à religião e o regime político estabelecido.
# 
# ## Banco de dados: Quality of Government 
# 
# Vamos utilizar o [Quality of Government](https://qog.pol.gu.se/) para selecionar 
# algumas características importantes dos sistemas políticos de diferentes países.
# 
# Trata-se de um projeto que organiza diferentes bases de dados relacionados a 
# Política Comparada e Relações Internacionais, facilitando análises de n grande. 
# Vale a pena olhar o livro de códigos!
#   
#   <!---**Abra o visualizador de dados em uma janela separada para acompanhar as alterações nos próximos slides!**--->
#   
#   ## 
#   <center>
#   > “Happy families are all alike; every unhappy family is unhappy in its own way.”
# >
#   > --- Liev Tolstoi
# 
# > “Tidy datasets are all alike; every messy dataset is messy in its own way.”
# >
#   > --- Hadley Wickham
# 
# </center>
#   
#   ## Tidy Data vs. Messy Data
#   ![Tidy Dataset](images/tidy.png)
# 
# - No mundo real, a grande maioria dos dados não vai estar no formato que desejamos. 
# Nessa aula vamos aprender a processar os dados para que eles fiquem *tidy* de acordo com 
# nossos objetivos.
# 
# ## *Tidyverse*
# Todas as  ferramentas que vamos ver fazem parte do [tidyverse](https://www.tidyverse.org/), 
# um conjunto de pacotes para tratamento de bases de dados.
# 
# ```{r message=FALSE, warning=FALSE}
# # install.packages("tidyverse")
library(tidyverse)
# ```
# 
# Esse conjunto de pacotes segue um conjunto de princípios que estão se tornando o 
# padrão de análise de dados no `R`.
# 
# <center>
#   ![Tidyverse](images/tidyverse.PNG){width=600px}
# </center>
#   
#   <center>
#   [The tidy tools manifesto](https://cran.r-project.org/web/packages/tidyverse/vignettes/manifesto.html)
# <center>
#   
#   ## 
#   <center>
#   ![Pipe](images/pipe.png){width=300px}
# </center>
#   
#   O *pipe* (`%>%`) deixa a ordem das operações mais clara, tornando o código mais 
# fácil de ler e de compreender.
# 
# ```{r eval=FALSE, echo=TRUE}
# Um vetor qualquer
x <- c(1:10)

# Um cálculo simples com código complicado
sum(sqrt(factorial(x)))

# O mesmo cálculo com %>% 
x %>% factorial() %>% sqrt() %>% sum()
# ```

# ## Exercício
# 
# - Utilizando o operador `%>%` e as funções `sqrt()` e `plot()` obtenha uma visualização
# da raiz quadrada de cada um dos elementos do vetor abaixo:
#   
#   ```{r eval=FALSE, echo=TRUE}
# # Vetor
x <- seq(0, 10, .1)

# ## Carregando dados
# 
# - É recomendável adotar a estrutura de projetos em sua 
# análise de dados ([Workflow: projects](https://r4ds.had.co.nz/workflow-projects.html)). 
# 
# - Otimiza a colaboração e o compartilhamento de sua análise ao sempre
# usar a estrutura do projeto como referência de seus arquivos.
# 
# - Como toda análise de dados pressupõe a existência dos mesmos, o `RStudio`
# usa o diretório do projeto como raiz e pode-se navegar facilmente por suas pastas.
# Para ajudar nessa tarefa, usamos o pacote `here`.
# 
# ## Carregando dados: exemplo prático
# 
# - Vamos carregar a principal base de dados dessa aula usando a função `read_csv` e
# alocá-la num objeto chamado `qog`:
#   
#   ```{r eval=FALSE, echo=TRUE}
library(here)

# importando base de dados
qog <- read_csv(here("data", "qog_bas_ts_jan20.csv"))

# ```
# 
# ## Carregando dados: outras possibilidades
# 
# Praticamente todo tipo de estrutura de dados pode ser importada para análise no `R`. 
# Os seguintes pacotes `tidyverse` são recomendados:
#   
#   - `haven`: para formatos SPSS, Stata, e SAS.
# - `readxl`: para arquivos do Microsoft Excel (.xls e .xlsx).
# - `DBI`: para RMySQL, RSQLite, RPostgreSQL, etc.
# - `jsonlite`: para json.
# - `xml2` para XML. 
# 
# ## Verbos
# No `tidyverse` vamos tratar de **verbos** (funções) que descrevem passo-a-passo as 
# tarefas de processamento necessárias:
#   
#   - Selecionar casos com `filter()`
# -  Ordenar variáveis com `arrange()`
# -  Processar colunas com `select()` e `rename()`
# -  Criar variáveis com `mutate()`
# -  Recodificar variáveis com `case_when()`
# -  Resumir informações com `summarise()` e `group_by()`
# -  Reorganizar bases com `pivot_wider()` e `pivot_longer()`
# -  Mesclar bases com `left_join()`
# -  Combinar diferentes passos de processamento
# -  Aplicação
# 
# ## Selecionar colunas com `select()`
# Em uma bases de dados com um número muito grande de colunas, você pode querer 
# selecionar apenas aquelas que são mais importantes para uma determinada tarefa.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # Selecionar apenas variáveis de democracia
qog %>% 
  select(cname, chga_demo, p_polity2)

# Selecionar todas as colunas menos duas
qog %>% 
  select(-(3:4))
# ```
# 
# ## Selecionar colunas com `select()`
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # Algumas funções mais específicas
banco_mundial <- qog %>% 
  select(starts_with("wb"))

welfare <- qog %>% 
  select(ends_with("_wel"))

# Alterar a ordem de apresentação das variáveis
qog <- qog %>% 
  select(chga_demo, p_polity2, everything())

# ```
# 
# ## Renomear variáveis com `rename()`
# A função `rename()` é prima da `select()`. Com ela, conseguimos trocar o nome de uma variável (`select()` também faz isso, mas apaga todas as outras variáveis do banco)
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # IMPORTANTE: o novo nome da variável vem primeiro
qog %>% 
  rename(democracia = chga_demo) %>% 
  select(cname, democracia)

# ```
# 
# ## Criar variáveis com `mutate()`
# <center>
#   ![Mutate](images/mutate.png){width=500px}
# </center>
#   
#   Esse é um dos comandos mais úteis de todo pacote. Frequentemente, as bases de dados não têm 
# todas as informações que queremos, mas podemos criar nossas próprias variáveis a partir das
# já existentes.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # Note que as variáveis ccode e year continuam no banco de dados
qog %>% 
  mutate(ID = paste0(ccode, "/", year)) %>% 
  select(cname, ID)

# O comando transmute faz a mesma coisa, mas só mantém a variável nova
qog %>% 
  transmute(ID = paste0(ccode, "/", year))

# ```
# 
# ## Recodificar variáveis com `case_when()`
# Uma das funções mais úteis para ser usada com o `mutate()` é o `case_when()`. Com ela, 
# podemos recodificar nossas variáveis para criar faixas de idade, salário, sexo, etc. 
# 
# **Importante**: sempre opere do caso específico para o geral.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # Criar variável dummy para reclassificação do Polity IV
qog %>% 
  mutate(pol_bin = case_when(p_polity2 >= 7 ~ "Democracia",
                             TRUE ~ "Autocracia")) %>% 
  select(cname, pol_bin, p_polity2)

# Podemos ter mais de duas condições
qog %>% 
  mutate(pol_cat = case_when(p_polity2 > 7 ~ "Muito Democrático",
                             p_polity2 > 5 & p_polity2 <= 7 ~ "Democrático",
                             TRUE ~ "Autocracia")) %>%
  select(cname, pol_cat, p_polity2) %>% arrange(desc(p_polity2))

# ```


# ## Selecionar casos com `filter()`
# <center>
#   ![Filter](images/filter.png){width=700px}
# </center>
#   
#   O comando `filter()` **seleciona observações**, como o filtro do Excel.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
qog %>% 
  filter(year == 2015)
# ```

# ## Relembrando os operadores lógicos
# <center>
#   ![Operadores lógicos](images/transform-logical.png){width=500px}
# </center>
#   
#   Podemos usar operadores lógicos para aplicar filtros com múltiplos critérios, 
# assim como armazenar os resultados em um novo objeto.
# 
# ```{r eval=FALSE, echo=TRUE}
qog %>% 
  filter(year == 2000 & chga_demo == 1) %>%
  select(cname, year, chga_demo)
# 
# ```
# 
# 
# ## Ordenar variáveis com `arrange()`
# 
# <center>
#   ![Arrange](images/arrange.png){width=500px}
# </center>
#   
#   O comando `arrange()` ordena o banco de dados com base na variável que você selecionar. 
# Variáveis adicionais serão usadas como critério de desempate
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # Ordenamento padrão é ascendente
qog %>% 
  arrange(chga_demo, p_polity2) %>%
  select(cname, year, p_polity2)

# Ordenamento descendente
qog %>% 
  arrange(desc(p_polity2)) %>%
  select(cname, year, p_polity2)
# ```
# 
# 
# ## Resumir informações com  `summarise()` e `group_by()`
# 
# O comando `summarise()` resume os dados. O `summarise()` fica mais interessante quando utilizado em conjunto com o `group_by()`, que permite agrupar as observações de acordo com categorias de uma variável que você escolher, criando subtotais.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
qog %>% 
  group_by(year, ht_region) %>% 
  summarise(cristao = mean(arda_chgenpct),
            islamico = mean(arda_isgenpct),
            judeu = mean(arda_jdgenpct)) %>% drop_na()
# ```
# 
# Além da função `mean()` utilizada acima, outras funções úteis são `sum()`, `median()`, `sd()`, 
# `n()` e `n_distinct()`.

# ## Outras funções para agrupar
# A função `group_by` pode ser combinada com outras funções que vimos acima para 
# separar operações por grupo:
#   
#   **Importante**: Depois de fazer a operação agrupada, voltamos à forma inicial da base 
# com o comando `ungroup()`. Se não fizermos isso, todas as próximas operações nesse 
# objeto serão aplicadas por grupo.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
qog_group <- qog %>% 
  group_by(year, ht_region, p_polity2) %>% 
  summarise(cristao = mean(arda_chgenpct),
            islamico = mean(arda_isgenpct),
            judeu = mean(arda_jdgenpct)) %>%
  arrange(p_polity2) %>% 
  ungroup()

qog_group
# ```
# 
# ## Exercício
# 
# Crie o objeto `qog_group` que seja o resultado do cálculo da mediana `median()` 
# da preponderância das religiões cristã, islâmica e judaica por região 
# (`ht_region`) no ano (`year`) de 2000:
#   
#   ```{r eval=FALSE, echo=TRUE}

# ```
# 
# ## Exercício: resposta
# 
# Crie o objeto `qog_group` que seja o resultado do cálculo da mediana `median()` 
# da preponderância das religiões cristã, islâmica e judaica por região 
# (`ht_region`) no ano (`year`) de 2000:
#   
#   ```{r eval=FALSE, echo=TRUE}

# ```
# 
# ## Reorganizar bases com `pivot_wider()` e `pivot_longer()`
# A melhor maneira de entender a utilidade das funções `pivot_wider()` e `pivot_longer()` 
# é por meio de um exemplo.
# 
# <center>
#   ![Wide e Long Data](images/wide_long.PNG){width=400px}
# </center>
#   
#   Nossa base de dados está em um formato **long**, ou seja: cada país/ano está em uma linha, 
# e seus atributos estão em colunas. Você pode ter notado que este é, também, o formato *tidy*. 
# 
# **Nota**: É muito mais comum precisar fazer a transformação **wide** --> **long** do 
# que o contrário!
#   
#   ## `privot_wider()`: transforma dados *long* em *wide*
#   <center>
#   ![Spread](images/spread.PNG)
# </center>
#   
#   Vamos produzir uma matriz com países (`cname`) nas linhas, anos (`year`) nas 
# colunas e o valor da variável `p_polity2` em cada elemento.

# `p_polity2`: "Revised Combined Polity Score: The polity score is computed by subtracting the p_autoc score from the p_democ score; the resulting unified polity scale ranges from +10 (strongly democratic) to -10 (strongly autocratic)."

# ## `privot_wider()`: transforma dados *long* em *wide*
# <center>
#   ![Spread](images/spread.PNG)
# </center>
#   
#   ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
qog_wide <- qog %>% select(cname, year, p_polity2) %>%
  pivot_wider(names_from = year, values_from = p_polity2)

qog_wide
# ```
# 
# ## `pivot_longer()`: transforma dados *wide* em *long*
# <center>
#   ![Gather](images/gather.PNG)
# </center>
#   
#   Vamos usar o objeto `qog_wide` que criamos e colocá-lo em seu formato original 
# com a função `pivot_longer()`.
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
qog_long <- qog_wide %>% 
  pivot_longer(-cname, names_to = "year", values_to = "p_polity2")

qog_long
# ```

# ## Unindo bases de dados
# <center>
#   *"There are two certainties in life: death and bad merges"*
#   </center>
#   
#   Nem sempre (quase nunca) as informações que queremos vão estar em uma única base de dados. Nesses casos, precisamos *unir* duas ou mais bases, um processo que exige atenção. 
# 
# Existem diversos comandos para fazer essa operação. Contudo, vamos focar no que o `tidyverse` 
# nos oferece, em especial o `left_join()`. Vamos ver um exemplo:
#   
#   ## Unindo bases de dados
#   
#   <center>
#   ![Flights](images/flights.png){width=600px}
# </center>
#   
#   - **flights** se conecta a `planes` por: `tailnum`.
# - **flights** se conecta a `airlines` por: `carrier`.
# - **flights** se conecta a `airports` por: `origin` e `dest`.
# - **flights** se conecta a `weather` por: `origin`, `year`, `month`, `day`, `hour`.
# 
# ## Comandos para unir bases: 
# <center>
#   ![Join](images/join.png){width=900px}
# </center>
#   
#   <center>
#   ![JoinF](images/merge.png){width=800px}
# </center>
#   
#   ## Comandos para unir bases: `full_join()`
#   <center>
#   ![full](images/full_join.png){width=900px}
# </center>
#   
#   ## Comandos para unir bases: `inner_join()`
#   <center>
#   ![inner](images/inner_join.png){width=900px}
# </center>
#   
#   ## Comandos para unir bases: `right_join()`
#   <center>
#   ![right](images/right_join.png){width=900px}
# </center>
#   
#   ## Comandos para unir bases: `left_join()`
#   <center>
#   ![left](images/left_join.png){width=900px}
# </center>
#   
#   ## Material adicional
#   Alguns materiais interessantes para consulta:
#   
#   - [Primer: Tidy your Data](https://rstudio.cloud/learn/primers/4)
# - [Data Transformation Cheat Sheet](https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf)
# - [Data Visualization Cheat Sheet](https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf)
# 
# ## Tarefa da aula
# 
# As instruções da tarefa estão no arquivo `NN-class-ds4ir-assignment.rmd` da pasta 
# `assignment` que se encontra na raiz desse projeto.








