# Fingerprint Feature Extraction using Empirical Mode Decomposition (EMD)

This project demonstrates a **fingerprint feature extraction pipeline** using **Empirical Mode Decomposition (EMD)** in MATLAB.  
The approach enhances ridge structures and detects minutiae points for biometric authentication.

---

## 📌 Features
- Preprocessing: grayscale conversion, normalization, and contrast enhancement  
- EMD-based decomposition of fingerprint images into Intrinsic Mode Functions (IMFs)  
- Ridge feature extraction from selected IMFs  
- Adaptive thresholding and binarization for ridge enhancement  
- Minutiae detection using morphological operations (`bwmorph`)  
- Visualization of IMFs, ridge features, and detected minutiae points  

---

## 🛠 Requirements
- MATLAB R2019a or later (earlier versions may also work)
- Image Processing Toolbox
- EMD Toolbox for MATLAB (e.g., `emd.m` function)

---

## 📂 Project Structure
