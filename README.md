# Comparing Corner Detectors in MATLAB

This project aims to compare the corner detection algorithms present in MATLAB to the number of matches they can produce in a pair of stereo images.

## Introduction

Stereo vision is one of the areas of digital image processing that seeks to reconstruct a scene, in three dimensions, from a set of images obtained from it. One of the requirements for the reconstruction of a three-dimensional scene to be satisfactory is that the scene reconstruction algorithm is capable of recognizing common points that belong to the same object within the input images. This process of associating such points is called correspondence [1]. In general, the matching algorithms use the corners of the objects present in the analyzed images as reference for such a process.

Since there are several corner detecting algorithms in the literature, the corner detector chosen may directly impact the correspondence quality between a set of stereo images. So, this project aimed to make a comparison between the main corner detection algorithms, verifying their impact on the production of matches between pairs of stereo images.

## Utilized Material

- [**MATLAB R2017b**](https://www.mathworks.com/products/matlab.html) ou posterior, versão x64.
- A set of stereo images, available on the [Middlebury](http://vision.middlebury.edu/stereo/data/) database, for the tests.

## Additional Info

Since this project is in a "work-in-progress" state, a lot of thing can change until I finished it.

## License

The available source codes here are under the MIT License, version 3.0 (see the attached `LICENSE` file for more details). Any questions can be submitted to my email: carloswdecarvalho@outlook.com.

## References

[1] Hartley, R; Zisserman, A. "Multiple View Geometry in Computer Vision". Cambridge University Press, 2003.