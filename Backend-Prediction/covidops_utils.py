# -*- coding: utf-8 -*-
"""covidops_utils.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1u8ZBsAU6Sx2wtaFNpTfBxKXRoyLFuGKa
"""

import pandas as pd
import numpy as np
import librosa
from joblib import dump, load
import keras
import matplotlib.pyplot as plt
import cv2
import soundfile as sf

#Features to be extracted
features =  [
                'chroma_stft', 'rmse', 'spectral_centroid', 'spectral_bandwidth', 'rolloff', 'zero_crossing_rate',
                'mfcc1', 'mfcc2', 'mfcc3', 'mfcc4', 'mfcc5', 'mfcc6', 'mfcc7', 'mfcc8', 'mfcc9', 'mfcc10', 
                'mfcc11', 'mfcc12', 'mfcc13', 'mfcc14', 'mfcc15', 'mfcc16', 'mfcc17', 'mfcc18', 'mfcc19', 'mfcc20'
            ]

# loading normalizer
scaler = load('std_scaler.bin')

# loading preprocessor function
def preprocessAUDIO(fn_wav):
    y, sr = librosa.load(fn_wav, mono=True, duration=5)
    chroma_stft = librosa.feature.chroma_stft(y=y, sr=sr)
    rmse = librosa.feature.rms(y=y)
    spectral_centroid = librosa.feature.spectral_centroid(y=y, sr=sr)
    spectral_bandwidth = librosa.feature.spectral_bandwidth(y=y, sr=sr)
    rolloff = librosa.feature.spectral_rolloff(y=y, sr=sr)
    zcr = librosa.feature.zero_crossing_rate(y)
    mfcc = librosa.feature.mfcc(y=y, sr=sr)
    
    feature_row = {        
        'chroma_stft': np.mean(chroma_stft),
        'rmse': np.mean(rmse),
        'spectral_centroid': np.mean(spectral_centroid),
        'spectral_bandwidth': np.mean(spectral_bandwidth),
        'rolloff': np.mean(rolloff),
        'zero_crossing_rate': np.mean(zcr),        
    }
    for i, c in enumerate(mfcc):
        feature_row[f'mfcc{i+1}'] = np.mean(c)

    df = pd.DataFrame(columns = features)
    df = df.append(feature_row, ignore_index = True)
    X_test = scaler.transform(df)

    return X_test[0]

'''
toPreds = preprocessAUDIO('/content/pos-0421-084-cough-m-50-4.mp3')
toPreds
'''

def preprocessIMG(path):
    image1 = plt.imread(path)
    image1 = cv2.resize(image1, (224, 224))
    image1 = cv2.cvtColor(image1, cv2.COLOR_BGR2RGB)
    images = []
    images.append(image1)
    images = np.array(images) / 255.0
    return images

'''
toPreds = preprocessIMG('/content/download.jpg')
toPreds.shape
'''