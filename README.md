# Additive_vs_diffusive
Data (Additive versus diffusive coupling paper)

This repository contains the networks used in the manuscript "The interaction between neural populations: Additive versus diffusive coupling" by Lopes et al.

There are two directories: 
- Artificial_networks
- MEG_networks

The "Artificial_networks" directory contains 8 subdirectories, each one for a different type of network topology used in the study: "RD" stands for random networks, "SF" stands for scale-free networks, "UN" corresponds to undirected networks, "DN" corresponds to directed networks, "c4" is for networks with mean degree equal 4, and "c8" is for networks with mean degree equal 8. In each subdirectory there are the 10 examplary networks used in the study for each network topology.

The "MEG_networks" directory contains 52 functional networks obtained from resting-state MEG data. Each file contains a 'label' variable which indicates whether the networks was obtained from a person with epilepsy, or a healthy control. 

All networks are provided as .mat files which can be loaded in MATLAB. 
More details about the networks are given in the manuscript. 
