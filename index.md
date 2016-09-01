---
title       : "rtip: paquete para el análisis de la pobreza y la desigualdad"
subtitle    : "XXXVI Congreso Nacional de la SEIO"
author      : "C.D. Ramos, A. Berihuete, M.A. Sordo"
#logo        : LogoUCA.png
duration    : 17
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
bibliography: rtip.bib
csl: annual-review-of-statistics-and-its-application.csl
---




## Introducción
### Justificación

Proyecto: Desigualdad y pobreza en Andalucía: un estudio    comparativo con los países de la Unión Europea (2005-2010), PRY103/12, Centro de Estudios Andaluces (aprobado en la 8.ª edición de la Convocatoria Pública de Proyectos de Investigación en el año 2012 de la Fundación Centro de Estudios Andaluces). 

Equipo de investigación: M.A. Sordo Díaz (Coord.),  A. Berihuete Macías y C.D. Ramos González. 

Publicaciones generadas: 

Las conclusiones del estudio realizado se recogen en las publicaciones:

   1. Desigualdad y pobreza en Andalucía: un estudio comparativo con los países de la Unión Europea (2005-2010) (Factoría de Ideas, 15 de mayo 2014, Centro de Estudios Andaluces)
   2. Bienestar, desigualdad y pobreza en Andalucía: un estudio comparativo con el resto de España a partir de las encuestas de condiciones de vida 2006 y 2012 (Colección Actualidad Nº 71, 13 de noviembre 2014, Centro de Estudios Andaluces)

---

## Introducción
### Indicadores y curvas proporcionadas por rtip 

Análisis Pobreza | Análisis Desigualdad
----------------------------------------- | ------------------------------ 
Umbral de riesgo de pobreza (*arpt*)  | Coeficiente de Gini (*gini*) | miuc
Tasa de riesgo de pobreza (*arpr*)    | Ratio de quintiles, S80/S20 (*qsr*) 
Desfase relativo de la renta mediana de la población en riesgo de pobreza (*rmpg*)      | Curva de Lorenz (*lc*)     
Índice FGT(1) [@FGT1984] (*s1*)                      | __Análisis Bienestar__
Índice SST [@Shorrocks1995]  (*s2*) | Rentas medias por hogar, persona y u.c. (*mih*, *mip*, *miuc*)
Curva TIP [@Shorrocks1995 ; @Jenkins1997] (*tip*) | Curva de Lorenz Generalizada (*lc*) 

(*) Ver manual de referencia [@rtip].

Para su cálculo la información se obtiene de las encuestas EU-SILC (European Union Statistics on Income and Living Conditions) proporcionadas por Eurostat, y de las Encuestas de Condiciones de Vida (ECV) proporcionadas por el INE.

---

## Introducción 

### ¿Qué había sobre estas herramientas en R? 

> __ineq__ : Measuring Inequality, Concentration and Poverty (C. Gini, C. Lorenz y Lorenz Generalizada, Índices de pobreza de Foster y SST, entre otros)  

> __IC2__ :  Inequality and Concentration Indices and Curves (C. SGini, C. Lorenz y Lorenz Generalizada)

> __laeken__[@Alfons2013]: Estimation of indicators on social exclusion and poverty (*arpt*, *arpr*, *rmpg*, *qsr*, *gini*).

<!-- ¿En __STATA__, los módulos: -->
<!-- * __svylorenz__ : derives distribution-free variance estimates from complex survey data, of quantile group shares of a total, cumulative quantile group shares -->
<!-- * __sumdist__ : calculates summary statistics for income distributions -->
<!-- * __ineqdeco__: calculates inequality indices with decomposition by subgroup -->
<!-- * __povdeco__: calculates poverty indices with decomposition by subgroup -->
<!-- * __glcurve__: derives generalised Lorenz curve ordinates -->

<!-- Autor: Stephen P. Jenkins (referencia)? 
<!-- DAD @Buhmann1988 -->


### Aportaciones del paquete rtip

> La información: la extrae de las encuestas EU-SILC y ECV.

> Para los indicadores: estimaciones puntuales e intervalos de confianza mediante bootstrap.

> Para las curvas: estimaciones de las ordenadas y tests dominancia [@Xu1997; @XuOsberg1998]

> Permite realizar comparaciones temporales y entre países o regiones.

---

## Instalación del paquete

> Desde [Github](https://github.com/AngelBerihuete/rtip)

```r
install.packages("devtools")
devtools::install_github("AngelBerihuete/rtip")
```

> Desde [CRAN](https://cran.r-project.org/web/packages/rtip/index.html)

```r
install.packages("rtip")
```
Una vez instalado basta ejecutar 

```r
library(rtip)
```

---

## Carga de datos
### Las funciones __loadLCS__ y __loadEUSILC__

Pueden cargarse datos tanto del INE (ECV) como de Eurostat (EU-SILC) con las funciones


```r
loadLCS(lcs_d_file, lcs_h_file)
loadEUSILC(eusilc_d_file, eusilc_h_file)
```

Vamos a trabajar durante la presentación con datos contenidos en el propio paquete


```r
data("LCS2014")
head(LCS2014,3)
```

```
##   DB010 DB020 DB040     DB090 HX040 HX050    HX090
## 1  2014    ES  ES21 2537.6406     1   1.0 13301.80
## 2  2014    ES  ES21  994.0731     4   2.3 13288.61
## 3  2014    ES  ES21 1267.6372     3   2.0 22005.05
```

--- 

## Carga de datos
### La función __setupDataset__

Una vez cargados los datos, la función __setupDataset__ selecciona el país, la comunidad y establece los argumentos según el estudio


```r
Andalucia <- setupDataset(LCS2014, country = "ES", region = "ES61",
                          s = "OECD", deflac = NULL, ppp = FALSE)
Castilla_La_Mancha <- setupDataset(LCS2014, region = "ES42")
Navarra <- setupDataset(LCS2014, region = "ES22")
head(Navarra, 3)
```

```
##      DB010 DB020 DB040    DB090 HX040 HX050    HX090     ipuc   wHX040
## 1439  2014    ES  ES22 900.9000     4   2.5 14237.92 14237.92 3603.600
## 1440  2014    ES  ES22 329.7968     5   3.0 14320.43 14320.43 1648.984
## 1441  2014    ES  ES22 889.7933     4   2.5 14633.92 14633.92 3559.173
```

---

## Indicadores de pobreza
### Algunos ejemplos para su cálculo: estimación puntual


```r
arpt(Andalucia, pz = 0.6, ci = FALSE, rep = 1000, verbose = FALSE)
```

```
## [1] 6091.28
```

```r
arpr(Andalucia, arpt(Andalucia))
```

```
## [1] 20.31785
```

```r
s1(Andalucia, arpt(Andalucia))
```

```
## [1] 498.4817
```

---

## Indicadores de pobreza
### Algunos ejemplos para su cálculo: intervalo de confianza

Intervalo al 95% de confianza para el umbral de riesgo de pobreza


```r
arpt(Andalucia, pz = 0.6, ci = TRUE, rep = 1000, verbose = FALSE)
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 1000 bootstrap replicates
## 
## CALL : 
## boot::boot.ci(boot.out = boot.arpt.value, type = "basic")
## 
## Intervals : 
## Level      Basic         
## 95%   (5761, 6348 )  
## Calculations and Intervals on Original Scale
```

---

## Indicadores de pobreza
### Recordamos los diferentes indicadores y curvas calculados por rtip

Análisis Pobreza | Análisis Desigualdad
----------------------------------------- | ------------------------------ 
Umbral de riesgo de pobreza (*arpt*)  | Coeficiente de Gini (*gini*) | miuc
Tasa de riesgo de pobreza (*arpr*)    | Ratio de quintiles, S80/S20 (*qsr*) 
Desfase relativo de la renta mediana de la población en riesgo de pobreza (*rmpg*)      | Curva de Lorenz (*lc*)     
Índice FGT(1) [@FGT1984] (*s1*)                      | __Análisis Bienestar__
Índice SST [@Shorrocks1995]  (*s2*) | Rentas medias por hogar, persona y u.c. (*mih*, *mip*, *miuc*)
Curva TIP [@Shorrocks1995 ; @Jenkins1997] (*tip*) | Curva de Lorenz Generalizada (*lc*)  

Para su cálculo la información se obtiene de las encuestas EU-SILC (European Union Statistics on Income and Living Conditions) proporcionadas por Eurostat, y de las Encuestas de Condiciones de Vida (ECV) proporcionadas por el INE.

<!-- Análisis Pobreza | Análisis Desigualdad -->
<!-- ----------------------------------------- | ------------------------------  -->
<!-- Umbral de riesgo de pobreza (*arpt*)  | Coeficiente de Gini (*gini*) | miuc -->
<!-- Tasa de riesgo de pobreza (*arpr*)    | Ratio de quintiles, S80/S20 (*qsr*)  -->
<!-- Desfase relativo de renta mediana de población en riesgo de pobreza (*rmpg*)      | Curva de Lorenz (*lc*)      -->
<!-- Índice de pobreza FGT(1) (Foster, Greer and Thorbecke, 1984) (*s1*)                      | __Análisis Bienestar__ -->
<!-- Índice de pobreza SST (Shorrocks, 1995)  (*s2*) | Rentas medias por hogar, persona y u.c. (*mih*, *mip*, *miuc*) -->
<!-- Curva TIP (Shorrocks, 1995; Jenkins and Lambert, 1997) (*tip*) | Curva de Lorenz Generalizada (*lc*)   -->

<!-- Para su cálculo la información se obtiene de las encuestas EU-SILC (European Union Statistics on Income and Living Conditions) proporcionadas por Eurostat, y de las Encuestas de Condiciones de Vida (ECV) proporcionadas por el INE. -->

---&twocol

## La curva TIP 

Dada una distribución de renta $X$ y fijado un umbral de pobreza $z>0$, la curva TIP (Three I's of Poverty), denotada por $tip(p,z)$, donde $0 \leq p \leq 1$, porporciona para cada $p$, el acumulado de las brechas de pobreza per cápita del $100p \%$ de los individuos más pobres.


```r
tip(Andalucia, arpt.value = arpt(Andalucia), norm = FALSE, plot = TRUE)
```

*** =left
![plot of chunk unnamed-chunk-10](assets/fig/unnamed-chunk-10-1.png)

*** =right
Así, para una población de $n$ individuos tales que $x_1 \le x_2 \le \cdots \le x_n$ se tiene
$$
tip \left( \frac{i}{n},z \right) = \sum_{j = 1}^i \frac{(z-x_j)_{+}}{n}
$$
para $i=1,2, \dots n$ y donde $a_{+} = \max \{ 0, a \}$ [@Jenkins1997].

---&twocol

## Test para la dominancia TIP

Dadas dos distribuciones de renta $A$ y $B$ y un umbral de pobreza $z>0$,  diremos que la curva TIP A domina a la curva TIP B, si se verifica 

$$
tip_A(p,z) \geq tip_B(p,z), \,\, 0 \leq p \leq 1 
$$

*** =left

![plot of chunk unnamed-chunk-11](assets/fig/unnamed-chunk-11-1.png)

*** =right

¿Realmente la curva TIP de Andalucía domina a la de Castilla-La Mancha?

---

## Test para la dominancia TIP [@XuOsberg1998]

¿Realmentela curva TIP de Andalucía domina a la de Castilla-La Mancha?


```r
testTIP(Andalucia, Castilla_La_Mancha, pz = 0.6, same.arpt.value = arpt(ESP),
        norm = FALSE, samplesize = 50)
```

```
## $Tvalue
##              [,1]
## [1,] 5.391962e-07
## 
## $p.value
## [1] NA
## 
## $decision
## [1] "Do not reject null hypothesis"
```

---

## Test para la dominancia TIP [@XuOsberg1998]

¿Realmentela curva TIP de Andalucía domina a la de Castilla-La Mancha? 


```r
testTIP(Castilla_La_Mancha, Andalucia, same.arpt.value = arpt(ESP))
```

```
## $Tvalue
##          [,1]
## [1,] 16771.31
## 
## $p.value
## [1] NA
## 
## $decision
## [1] "Reject null hypothesis"
```


---&twocol

## Test para la dominancia TIP 

¿Qué sucede cuando usamos umbrales de pobreza diferentes en ambas distribuciones? 

*** =left

![plot of chunk unnamed-chunk-14](assets/fig/unnamed-chunk-14-1.png)

*** =right
¿Realmente la curva TIP de Andalucía domina a la de Castilla-La Mancha?


---

## Test para la dominancia TIP [@XuOsberg1998]

¿Qué sucede cuando usamos umbrales de pobreza diferentes en ambas distribuciones? 


```r
testTIP(Andalucia, Castilla_La_Mancha, pz = 0.6, norm = TRUE, samplesize = 50)
```

```
## $Tvalue
##              [,1]
## [1,] 4.546547e-11
## 
## $p.value
## [1] NA
## 
## $decision
## [1] "Do not reject null hypothesis"
```

---

## Test para la dominancia TIP [@XuOsberg1998]

¿Qué sucede cuando usamos umbrales de pobreza diferentes en ambas distribuciones? 


```r
testTIP(Castilla_La_Mancha, Andalucia, norm = TRUE)
```

```
## $Tvalue
##          [,1]
## [1,] 2675.343
## 
## $p.value
## [1] NA
## 
## $decision
## [1] "Reject null hypothesis"
```

---

## Apéndice

## Cómo dibujar varias curvas TIP


```r
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


```r
require(reshape2)
require(ggplot2)
ES61 <- lc(Andalucia, samp = 10, generalized = FALSE, plot = FALSE)
ES42 <- lc(Castilla_La_Mancha)
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


```r
testGL(Andalucia, Castilla_La_Mancha, generalized = TRUE, samplesize = 10)
```

```
## $Tvalue
##         [,1]
## [1,] 26843.9
## 
## $p.value
## [1] NA
## 
## $decision
## [1] "Reject null hypothesis"
```

---

## Tests para curvas Lorenz [@Xu1997]

¿Domina la curva de Lorenz para Castilla - La Mancha a la de Andalucía?


```r
testGL(Castilla_La_Mancha, Andalucia, generalized = TRUE, samplesize = 10)
```

```
## $Tvalue
##              [,1]
## [1,] 1.605208e-06
## 
## $p.value
## [1] NA
## 
## $decision
## [1] "Do not reject null hypothesis"
```


---

## Bibliografía