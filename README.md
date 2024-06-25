---
title: ""
output: 
  html_document:
    template: assets/template.html
    css: assets/style.css
    keep_md: true
editor_options: 
  markdown: 
    wrap: sentence
---


<br>
This repository contains data, code, and output for a project entitled "Working memory performance in adverse environments: Enhanced, impaired, or intact?". A Stage 1 snapshot of the project has been submitted to [Peer Community in Registered Reports (PCI-RR)](https://rr.peercommunityin.org/).

Do you want to download or clone the materials for this project? Go to [https://github.com/stefanvermeent/liss_wm_profiles_2023](https://github.com/stefanvermeent/liss_wm_profiles_2023).

## Directory Structure {#structure}

The names of each folder are intended to be self-explanatory.
There are eight top-level folders to organize the inputs and outputs of this project:

1.  [`Manuscript`](https://stefanvermeent.github.io/liss_wm_profiles_2023/manuscript/README.html): The Registered Report written in Quarto.
2.  [`Supplement`](https://stefanvermeent.github.io/liss_wm_profiles_2023/supplement/README.html): a supplemental text (to be submitted with the manuscript) documenting all secondary analyses in detail.
3.  [`Scripts`](https://stefanvermeent.github.io/liss_wm_profiles_2023/scripts/README.html): R-scripts that read, analyze, and produce all analysis objects.
4.  [`Materials`](https://stefanvermeent.github.io/liss_wm_profiles_2023/materials/README.html): JsPsych scripts of the Working Memory tasks.
4.  [`Data`](https://stefanvermeent.github.io/liss_wm_profiles_2023/data/README.html): Folder in which real LISS data can be placed to make the analyses fully reproducible. Note that we cannot openly share the raw data on the open repository. The folder contains simulated data to facilitate computational reproducibility in the absence of LISS access.
5.  [`Analysis Objects`](https://stefanvermeent.github.io/liss_wm_profiles_2023/analysis_objects/README.html): Folder containing all analysis objects (as produced by the analysis scripts).
6.  [`Codebooks`](https://stefanvermeent.github.io/liss_wm_profiles_2023/codebooks/README.html): lists of variable names, labels, and value labels (where applicable).

Click on each of the folders to get more details.

## Overview of project milestones

Below is an overview of all the project milestones, such as first-time data access, submissions, and revisions.
Data access events were automatically captured using custom code, which over the course of this project was collected in the R package `projectlog` [https://stefanvermeent.github.io/projectlog/](https://stefanvermeent.github.io/projectlog/).

- **[2024-06-25 14:53:58](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/fb048d8764291871fbb0d6e3de4aca880c90c7cd): Submission of stage 2 manuscript**
    - **Milestone:** Submission
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/fb048d8764291871fbb0d6e3de4aca880c90c7cd)
    

- **[2024-04-29 11:52:56](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/9dbbb90a82566421d7967010dba755b0faae773f): final SEM specification**
    - **Milestone:** Analysis
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/9dbbb90a82566421d7967010dba755b0faae773f)
    

- **[2024-04-04 09:20:20](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/a0be5183db79da2d3f752565d29097b8c4a72186.R): access to all working memory measures of new study**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash 59d61e1e763f394d277b7164c2154703
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/a0be5183db79da2d3f752565d29097b8c4a72186.R)
    

- **[2024-04-03 16:13:42](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/1c2d2e6b017aeb8ce96b1022cc62393e66e7cb55.R): Read subject IDs only of new data collection to filter IV data**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash a482ccaaea62b90b223a71e1c3ed9191
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/1c2d2e6b017aeb8ce96b1022cc62393e66e7cb55.R)
    

- **[2024-04-01 09:58:39](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/76539b6a145eef99ba237f8837ee40ba966158ae.R): access to all background variable waves in LISS archive**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash 06795c268ce6957b29760bfc3ff0d6ad
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/76539b6a145eef99ba237f8837ee40ba966158ae.R)
    

- **[2024-03-30 16:25:37](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/71d70ab79326ada925a66e4e695c2e1ae703389a.R): access to all income waves in LISS archive**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash 2ae792026b72c0037e3f260319f53a6c
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/71d70ab79326ada925a66e4e695c2e1ae703389a.R)
    

- **[2024-03-30 16:15:43](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/d7dd554d9061e035af12a0268034fbfebb623e71.R): access to all crime victimization waves in LISS archive, v2**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash 738eb9c7c1a6a621b6e83c2e04007e88
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/d7dd554d9061e035af12a0268034fbfebb623e71.R)
    

- **[2024-03-30 13:21:56](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/869bedb88af275fd01f5dc0a72e2776cea975e1c.R): access to all crime victimization waves in LISS archive**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash 7562d74565de35bdfdc495b1e867e5aa
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/869bedb88af275fd01f5dc0a72e2776cea975e1c.R)
    

- **[2024-03-12 03:04:17](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/b44155672fefc445831dad956a97aaa0fabc599e): Revision 1 for PCI-RR**
    - **Milestone:** Revision
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/b44155672fefc445831dad956a97aaa0fabc599e)
    

- **[2024-01-31 13:20:40](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/62fb84de1e12dc43d0b5da4e781932b8e255b2fb): update README files**
    - **Milestone:** List
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/62fb84de1e12dc43d0b5da4e781932b8e255b2fb)
    

- **[2024-01-31 13:20:40](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/62fb84de1e12dc43d0b5da4e781932b8e255b2fb): update README files**
    - **Milestone:** List
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/62fb84de1e12dc43d0b5da4e781932b8e255b2fb)
    

- **[2024-01-31 13:09:11](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/5ed452462b20e1f4c5f9e6f0f6523970cfdd032d): Resubmission of Stage 1 manuscript - inclusion of Study Design Plan**
    - **Milestone:** Submission
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/5ed452462b20e1f4c5f9e6f0f6523970cfdd032d)
    

- **[2024-01-30 17:11:13](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/78c08d29b50f16c1f43c206264ab1b29ed180a2a): Stage 1 manuscript submitted to PCI-RR**
    - **Milestone:** Submission
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/78c08d29b50f16c1f43c206264ab1b29ed180a2a)
    

- **[2023-10-26 13:32:15](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/46a2eaa2961e07f8d9f9b96af6a0b50661305a98): Final version of Stage 1 snapshot**
    - **Milestone:** Snapshot
    - **Data MD5 hash**: Not applicable
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/tree/46a2eaa2961e07f8d9f9b96af6a0b50661305a98)
    

- **[2023-05-01 09:41:18](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/82f126ec06653b3794b6bb710b8a04b4e697d630.R): Crime Victimization Data Wave 4, shuffled ids**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash b56b2940d7818fa2943bdfb232239d33
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/82f126ec06653b3794b6bb710b8a04b4e697d630.R)
    

- **[2023-05-01 09:40:53](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/598922e78bf7abcc1b5160e06355e32a73d02be5.R): Crime Victimization Data Wave 5, shuffled ids**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash a2791cce07d82ce930fa99903994e7d0
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/598922e78bf7abcc1b5160e06355e32a73d02be5.R)
    

- **[2023-05-01 09:37:28](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/fcaf6747766662ee20f9709a2d0262b766ea4500.R): Crime Victimization Data Wave 6, shuffled ids**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash 2ca883ca56dfe4ac39d94c13f5d322e2
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/fcaf6747766662ee20f9709a2d0262b766ea4500.R)
    

- **[2023-05-01 09:34:57](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/8f4ce9b0862b8107c7d02b93646c8d21374d40d2.R): LISS background variables January 2023, shuffled ids**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash a7e69cc50c4d617bee9f6e304ed09ae2
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/8f4ce9b0862b8107c7d02b93646c8d21374d40d2.R)
    

- **[2023-05-01 09:33:43](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/4904078af6fd51f7430a2b25997b5ea307a51a19.R): LISS background variables March 2023, shuffled ids**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash a2adc53b35b044fd34b61ebc319f4455
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/4904078af6fd51f7430a2b25997b5ea307a51a19.R)
    

- **[2023-05-01 09:22:26](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/405be71518cfc40e3de09f82e499412a9b29ee64.R): LISS background variables March 2023, shuffled ids**
    - **Milestone:** Data Access
    - **Data MD5 hash**: object_hash fd7a8e3b5f28c625d2ee8abf02545bc1
    - [Link to code snippet](https://github.com/StefanVermeent/liss_wm_profiles_2023/blob/master/405be71518cfc40e3de09f82e499412a9b29ee64.R)
    


