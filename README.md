# CardiacAR: Mobile Augmented Reality for Cardiovascular Surgical Planning

[![License](https://img.shields.io/badge/license-MIT-green)](https://github.com/poloclub/CardiacAR/blob/main/LICENSE)
[![DOI:10.1145/3429360.3468195](https://img.shields.io/badge/DOI-10.1145%2F3429360.3468195-blue)](https://dl.acm.org/doi/10.1145/3429360.3468195)

An augmented reality-based iOS application aimed to facilitate cardiovascular surgical planning.


<img src="img/README_Banner.png" width=80% alt="CardiacAR Banner">

<!-- [**Live Demo** - Launch Argo Scholar in your browser](https://poloclub.github.io/argo-scholar/) -->
<!-- ## Documentations 


- [Quick Start (Visualization, Saving and Sharing Snapshots)](quickstart.md)
- [Tutorial - Visualizing a citation network of Apolo (Initialize Network, Incremental Exploration, Saving Progress)](tutorial.md)
- [Develop Argo Scholar](development.md)
- [Deploy Argo Scholar (and custom sharing service with access)](deploy.md) -->

## Feature Highlights

### Importing and Repositioning Model

Import your own custom heart models and reposition them in the physical space!

![CardiacAR Model Import and Reposition](./img/Import%20and%20Reposition%20Model.gif)


### Panning, Scaling, and Perspective View

Using CardiacAR, you can pan, rotate, and scale the model for better angles. You can also move your device through the model by moving it in the physical space to obtain a perspective view of the model.

![CardiacAR Panning, Scaling, and Perspective View](./img/Pan%2C%20Scale%2C%20Perspective.gif)

### Model Slicing

Explore various cross sections of the model to beter understand the details of the heart model. Implement multiple slices and cross sections to narrow your field of view. Preview the slices before confirming them using the "Confirm Slice" button.

![CardiacAR Model Slicing](./img/Slicing.gif)

### Virtual Annotation
![CardiacAR Model Annotation](./img/Annotation.gif)

## Credits
♥ CardiacAR was developed and maintained by [Alex Yang](https://github.com/AlexanderHYang), [Pratham Mehta](https://github.com/twixupmysleeve), [Jonathan Leo](https://github.com/jpleo122), [Duen Horng Chau](https://github.com/polochau) from [Polo Club of Data Science](https://poloclub.github.io/) at Georgia Tech.
## Citation
```bibTeX
@inproceedings{10.1145/3429360.3468195,
   author = {Leo, Jonathan and Zhou, Zhiyan and Yang, Haoyang and Dass, Megan and Upadhayay, Anish and C Slesnick, 
   Timothy and Shaw, Fawwaz and Horng Chau, Duen},
   title = {Interactive Cardiovascular Surgical Planning via Augmented Reality},
   year = {2021},
   isbn = {9781450382038},
   publisher = {Association for Computing Machinery},
   address = {New York, NY, USA},
   url = {https://doi.org/10.1145/3429360.3468195},
   doi = {10.1145/3429360.3468195},
   abstract = { The current practice for planning complex cardiovascular surgeries includes printing
   and cutting physical heart models. Unfortunately, such cuts are permanent, thus it
   is not possible to interactively experiment with different cuts, slowing the planning
   process. In collaboration with Children’s Healthcare of Atlanta Heart Center (CHOA),
   we are exploring new ways to improve cardiovascular, or heart, surgical planning through
   augmented reality (AR). We are developing CardiacAR , an iOS AR application that enables
   interactive surgical planning on mobile devices. CardiacAR offers powerful and flexible
   tools critical for surgical planning, such as omni-directional slicing of patients’
   3D heart models and virtual annotation to assist planning. We believe the ubiquity
   of iOS devices will help broaden access to the CardiacAR technology and streamline
   its deployment.},
   booktitle = {Asian CHI Symposium 2021},
   pages = {132–135},
   numpages = {4},
   keywords = {ARKit, mixed reality, augmented reality, surgical planning},
   location = {Yokohama, Japan},
   series = {Asian CHI Symposium 2021}
 }
```

## License
CardiacAR is available under the  [MIT License](LICENSE).
CardiacAR uses the Euclid library, which is also licensed under the [MIT License](https://github.com/nicklockwood/Euclid/blob/master/LICENSE.md).


## Contact
If you have any questions or would like to contribute to the project, feel free to [open an issue](https://github.com/poloclub/CardiacAR/issues/new) or contact [Alex Yang](https://alexanderyang.me).
