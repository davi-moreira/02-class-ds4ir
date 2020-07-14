# title: "DS4IR"
# subtitle: "Processamento de Dados"
# author: 
# - Professor Davi Moreira
# - Professor Rafael Magalhães
# date: julho 2020

# packages ---------------------------------------------------------------------
library(tidyverse)
library(here)

## Pipe %>% --------------------------------------------------------------------

# Um vetor qualquer
x <- c(1:10)

# Um cálculo simples com código complicado
sum(sqrt(factorial(x)))

# O mesmo cálculo com %>% 
x %>% factorial() %>% sqrt() %>% sum()

## Exercício -------------------------------------------------------------------  

# - Utilizando o operador `%>%` e as funções `sqrt()` e `plot()` obtenha uma visualização
# da raiz quadrada de cada um dos elementos do vetor abaixo:
  
# Vetor
x <- seq(0, 10, .1)

## Exercício: resposta

## Carregando dados ------------------------------------------------------------

# importando base de dados
qog <- read_csv(here("data", "qog_bas_ts_jan20.csv"))

qog

## Selecionar colunas com `select()` -------------------------------------------

# Selecionar apenas variáveis de democracia
qog %>% 
  select(cname, chga_demo, p_polity2)

# Selecionar todas as colunas menos duas
qog %>% 
  select(-(3:4))

## Selecionar colunas com `select()` -------------------------------------------

# Algumas funções mais específicas
banco_mundial <- qog %>% 
  select(starts_with("wb"))

welfare <- qog %>% 
  select(ends_with("_wel"))

# Alterar a ordem de apresentação das variáveis
qog <- qog %>% 
  select(chga_demo, p_polity2, everything())

## Renomear variáveis com `rename()` -------------------------------------------

# IMPORTANTE: o novo nome da variável vem primeiro
qog %>% 
  rename(democracia = chga_demo) %>% select(cname, democracia)

## Criar variáveis com `mutate()` ----------------------------------------------

# Note que as variáveis ccode e year continuam no banco de dados
qog %>% 
  mutate(ID = paste0(ccode, "/", year)) %>% 
  select(cname, ID)

# O comando transmute faz a mesma coisa, mas só mantém a variável nova
qog %>% 
  transmute(ID = paste0(ccode, "/", year))

## Recodificar variáveis com `case_when()` -------------------------------------

# Criar variável dummy para reclassificação do Polity IV
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

## Selecionar casos com `filter()` ---------------------------------------------
qog %>% 
  filter(year == 2015)

## Relembrando os operadores lógicos -------------------------------------------

qog %>% 
  filter(year == 2000 & chga_demo == 1) %>% 
  select(cname, year, chga_demo)

## Ordenar variáveis com `arrange()` -------------------------------------------

# Ordenamento padrão é ascendente
qog %>% 
  arrange(chga_demo, p_polity2) %>%
  select(cname, year, p_polity2)

# Ordenamento descendente
qog %>% 
  arrange(desc(p_polity2)) %>%
  select(cname, year, p_polity2)

## Resumir informações com  `summarise()` e `group_by()`------------------------

qog %>% 
  group_by(year, ht_region) %>% 
  summarise(cristao = mean(arda_chgenpct),
            islamico = mean(arda_isgenpct),
            judeu = mean(arda_jdgenpct)) %>% drop_na()

## Outras funções para agrupar -------------------------------------------------

qog_group <- qog %>% 
  group_by(year, ht_region, p_polity2) %>% 
  summarise(cristao = mean(arda_chgenpct),
            islamico = mean(arda_isgenpct),
            judeu = mean(arda_jdgenpct)) %>%
  arrange(p_polity2) %>% 
  ungroup()

qog_group

## Exercício -------------------------------------------------------------------

# Crie o objeto `qog_group` que seja o resultado do cálculo da mediana `median()` 
# da preponderância das religiões cristã, islâmica e judaica por região 
# (`ht_region`) no ano (`year`) de 2000:

## Exercício: resposta


## Reorganizar bases com `pivot_wider()` e `pivot_longer()` -------------------

## `privot_wider()`: transforma dados *long* em *wide* -------------------------

qog_wide <- qog %>% select(cname, year, p_polity2) %>%
  pivot_wider(names_from = year, values_from = p_polity2)

qog_wide

## `pivot_longer()`: transforma dados *wide* em *long* -------------------------
qog_long <- qog_wide %>% 
  pivot_longer(-cname, names_to = "year", values_to = "p_polity2")

qog_long

## Tarefa da aula --------------------------------------------------------------

# As instruções da tarefa estão no arquivo `NN-class-ds4ir-assignment.rmd` da pasta 
# `assignment` que se encontra na raiz desse projeto.








