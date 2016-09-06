@incollection{Shorrocks1998,
  author       = {Shorrocks, Anthony F.}, 
  title        = {Deprivation Profiles and Deprivation Indices},
  booktitle    = {The Distribution of Welfare and Household Production: International Perspectives},
  publisher    = {Cambridge University Press},
  year         = 1998,
  editor       = {Jenkins, Stephen P. and Kapteyn, Arie and van Praag, Bernard M. S.},
  chapter      = {11},
  pages        = {250-267},
  address      = {Cambridge},
}


`r citet(bib[["Alfons2013"]])`

```{r,echo=FALSE, warning=FALSE}
library(knitcitations)
cleanbib()
bib <- read.bibtex("rtip.bib")
```
```{r, echo=TRUE}
data("LCS2014")
head(LCS2014,3)
```

--- 
  
  ## Carga de datos
  ### La función __setupDataset__
  
  Una vez cargados los datos, la función __setupDataset__ selecciona el país, la comunidad y establece los argumentos según el estudio



---&twocol

## Test para la dominancia TIP 

¿Qué sucede cuando usamos umbrales de pobreza diferentes en ambas distribuciones? 

*** =left

```{r, warning=FALSE, echo=FALSE, fig.width = 6, fig.height = 6}
ESP <- setupDataset(LCS2014, country = "ES", region = "all")
ES61 <- tip(Andalucia, arpt.value = arpt(Andalucia), norm = TRUE)
ES42 <- tip(Castilla_LaMancha, arpt.value = arpt(Castilla_LaMancha), norm = TRUE)
ES22 <- tip(Navarra, arpt.value = arpt(Navarra), norm = TRUE)

ggplot(data = ES61, aes(x.tip,y.tip, color="ES61")) + 
  geom_line() + 
  geom_line(data = ES42, aes(x.tip, y.tip, color = "ES42")) +
  scale_x_continuous(expression(p),
                     limits = c(0, 0.5)) +
  scale_y_continuous("") +
  scale_color_discrete(labels = c("Castilla - La Mancha", "Andalucía"), name="Regiones") +
  theme(legend.justification=c(1,0), legend.position=c(1,0))
```

*** =right
¿Realmente la curva TIP de Andalucía domina a la de Castilla-La Mancha?


---
  
  ## Test para la dominancia TIP [@XuOsberg1998]
  
  ¿Qué sucede cuando usamos umbrales de pobreza diferentes en ambas distribuciones? 

```{r, echo=TRUE}
testTIP(Andalucia, Castilla_LaMancha, pz = 0.6, norm = TRUE, samplesize = 50)

```

---
  
  ## Test para la dominancia TIP [@XuOsberg1998]
  
  ¿Qué sucede cuando usamos umbrales de pobreza diferentes en ambas distribuciones? 

```{r, echo=TRUE}
testTIP(Castilla_LaMancha, Andalucia, norm = TRUE)
```

---
  
  ## Apéndice
  
  ## Cómo dibujar varias curvas TIP
  
  ```{r, echo=TRUE, warning=FALSE, eval=FALSE}

ggplot(data = ES61, aes(x.tip,y.tip, color="ES61")) + 
  geom_line() + 
  geom_line(data = ES42, aes(x.tip, y.tip, color = "ES42")) +
  geom_line(data = ES22, aes(x.tip, y.tip, color = "ES22")) +
  scale_x_continuous("Cumulated proportion of population") +
  scale_y_continuous("") +
  scale_color_discrete(labels = c("Navarra", "Castilla - La Mancha", "Andalucía"), name="Regiones") + theme(legend.justification=c(1,0), legend.position=c(1,0))
```


---
  
  ## Cómo dibujar Varias curvas Lorenz
  
  ```{r, echo=TRUE, warning=FALSE, eval=FALSE}
require(reshape2)
require(ggplot2)
ES61 <- lc(Andalucia, samp = 10, generalized = FALSE, plot = FALSE)
ES42 <- lc(Castilla_LaMancha)
ES22 <- lc(Navarra)
data_regions <- data.frame(x = ES61$x.lg, 
                           ES61 = ES61$y.lg, 
                           ES42 = ES42$y.lg,
                           ES22 = ES22$y.lg)
dataset <- melt(data_regions, id = "x")
ggplot(data = dataset, aes(x,value, color=variable)) + 
  geom_line() + 
  geom_segment(aes(x = 0, y = 0, xend = 1, yend = 1),
               linetype = "longdash", color = "grey") +
  scale_x_continuous("Cumulated proportion of population") +
  scale_y_continuous("") +
  scale_color_discrete(labels = c("Andalucía","Castilla - La Mancha","Navarra"), name="Regiones") +
  theme(legend.justification=c(1,0), legend.position=c(1,0))
```


---
  
  ## Tests para curvas Lorenz [@Xu1997]
  
  ¿Domina la curva de Lorenz para Andalucía a la de Castilla - La Mancha?

```{r, warning=FALSE}
testGL(Andalucia, Castilla_LaMancha, generalized = TRUE, samplesize = 10)
```

---
  
  ## Tests para curvas Lorenz [@Xu1997]
  
  ¿Domina la curva de Lorenz para Castilla - La Mancha a la de Andalucía?

```{r, warning=FALSE}
testGL(Castilla_LaMancha, Andalucia, generalized = TRUE, samplesize = 10)
```


