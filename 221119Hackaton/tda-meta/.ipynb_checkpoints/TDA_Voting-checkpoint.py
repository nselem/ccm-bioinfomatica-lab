import pandas as pd
import gudhi as gd
from itertools import chain, combinations
import plotly.graph_objs as go
import numpy as np

#######################################
# Funciones para construir filtracion #
#######################################
def first_read(org,df):
    return set(df[df["Organism"]==org].Qname)

###########################################################
# Obtiene el conjunto de reads de una lista de organismos #
###########################################################
def get_read_from_organism(orgs):
    inter=orgs[0]
    for org in orgs:
        inter=inter.intersection(org)
    return inter

################################################
# Conjunto Potencia del conjunto de organismos #
################################################
def powerset(iterable):
    s = list(iterable)
    return list(chain.from_iterable(combinations(s, r) for r in range(1,min(len(s)+1,10))))

####################################
# Funcion auxiliar: Numero a lista #
####################################
def get_list(num):
    if isinstance(num, int):
        return [num]
    else:
        return list(num)
    
########################
# Persitencia de hoyos #
########################
def life_holes(simplexes,st):
    d_hole_time=dict()
    for simplex in simplexes:
        if len(simplex[0])>=3:
            boundaries=st.get_boundaries(simplex[0])
            hole_birth=max(boundaries, key=lambda tup: tup[1])
            t_birth=hole_birth[1]
            t_death=simplex[1]
            d_hole_time[tuple(simplex[0])]=(t_birth,t_death)
    return d_hole_time

################
# Funcion voto #
################
def vote_function(org,d_holes):
    value=0
    for simplex in d_holes.keys():
        if set({org}).issubset(set(simplex)):
            inter=d_holes[simplex]
            value+=(len(simplex)-2)*(inter[1]-inter[0])
    return value

def vote_function_simplex_persistence(org,d_simplex):
    value=0
    for simplex in d_simplex.keys():
        if set({org}).issubset(set(simplex)):
            inter=d_simplex[simplex]
            value+=(len(simplex)-1)*(inter[1]-inter[0])
    return value
    

#####################
# Funcion Principal #
#####################
def ranking_function_cech(df_mapping):
    # Organismos
    organisms=list(df_mapping["Organism"].unique())
    index_organisms=range(len(organisms))
    
    # Cardinalidades de los conjuntos
    d=dict()
    index_sets_organisms=powerset(index_organisms)
    for Y in index_sets_organisms:
        if len(Y)==1:
            d[Y[0]]=first_read(organisms[Y[0]],df_mapping)
        else:
            d[Y]=get_read_from_organism([d[i] for i in Y])  
            
    # Cardinalidades ordenadas
    d_order_cards_list=dict()
    d_cards=dict()
    for key in d:
        d_cards[key]=len(d[key])
    d_order_cards={k: v for k, v in sorted(d_cards.items(), key=lambda item: item[1],reverse=True)}
    
    # Construccion de la filtracion
    list_order_keys=list(d_order_cards.keys())    
    t_max= d_order_cards[list_order_keys[0]]
    st = gd.SimplexTree()
    for key in list_order_keys:
        st.insert(get_list(key), filtration = t_max-d_order_cards[key])
    st_filtration = st.get_filtration() 
    
    # Persistencia y graficas
    st.compute_persistence()
    st_persistence=st.persistence()
    #ax1=gd.plot_persistence_diagram(st_persistence)
    #ax2=gd.plot_persistence_barcode(st_persistence,legend=True)
    # Votacion de organismos
    simplexes=list(st.get_simplices())
    simplex_sorted_dim = sorted(simplexes, key=lambda tup: len(tup[0]),reverse=True)
    d_simplex_time=dict()
    for tuple_simple in simplex_sorted_dim:
        if len(tuple_simple[0])==st.dimension()+1:
            t_birth=tuple_simple[1]
            t_death=tuple_simple[1]
            d_simplex_time[tuple(tuple_simple[0])]=(t_birth,t_death)
        else:
            t_birth=tuple_simple[1]
            t_death=simplex_sorted_dim[0][1]
            for simplex in d_simplex_time.keys():
                if set(tuple_simple[0]).issubset(set(simplex)):
                    if t_death>d_simplex_time[simplex][0]:
                        t_death=d_simplex_time[simplex][0]
            d_simplex_time[tuple(tuple_simple[0])]=(t_birth,t_death)
    #d_holes=life_holes(d_simplex_time,st)
    d_holes=life_holes(simplexes,st)
    # Ranking de votos
    d_votes=dict()
    for i in index_organisms:
        d_votes[organisms[i]]=vote_function(i,d_holes)
    rank_organisms={k: v for k, v in sorted(d_votes.items(), key=lambda item: item[1],reverse=True)}
    # Rankings normalizados
    rank_max=max(list(rank_organisms.values()))
    rank_org_normalized=dict()
    for org in rank_organisms:
        rank_org_normalized[org]=rank_organisms[org]/rank_max
    
    return rank_org_normalized

#############################################
# Obtiene los nombres cortos de los genomas #
#############################################
#def getIDnames(fname):
#    s, e = "TP", ".csv"
#    i, j = fname.index(s), fname.index(e)
#    fname = fname[i+len(s): j].split("_")[-1]
#    return fname.split("-")[:-1]

def getIDnames(file_string):
    tp_list = []
    start=file_string.find('_C')
    end=file_string.find('.',start+1)
    tp_list.append(file_string[start+1:end])
    return tp_list
#######################
# Funcion graficadora #
#######################
def graph_voting_functions(lists_voting,list_TP):
    figure =[]
    # Gracias de votacion
    for i,v in enumerate(lists_voting):
        df_aux=pd.DataFrame(v.items(),columns=["organisms","vote"])
        index_organisms=df_aux.index
        plot = go.Scatter(x=[i for i in index_organisms],
                y=list(df_aux.vote),
                      name=f"{tuple(list_TP[i])}",
                      showlegend=False
                       ) 
        figure.append(plot)
    # Agregar True Positives
    for i,v in enumerate(lists_voting):
        df_aux=pd.DataFrame(v.items(),columns=["organisms","vote"])
        for TP in list_TP[i]:
            try:
                plot = go.Scatter(x=[list(v.keys()).index(TP)],
                        y=[v[TP]],
                              name='TP',
                              mode='markers',
                              marker=dict(
                              color='LightSkyBlue',
                              size=5,
                              line=dict(
                              color='MediumPurple',
                              width=12)
                              ),
                              showlegend=False) 
              
            except:
                    pass
            figure.append(plot)
    # layout_yaxis_range=[-0.2,1.2])
    fig = go.Figure(figure)
    fig.update_layout(
        title=f"Funciones de Votacion TP{len(list_TP[0])}")
    fig.update_traces(marker=dict(size=8,
                                  line=dict(width=2,
                                            color='DarkSlateGrey')),
                      selector=dict(mode='markers'))
    fig.show()