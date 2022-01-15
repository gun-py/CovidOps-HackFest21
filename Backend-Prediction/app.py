#app.py
from flask import Flask, json, request, jsonify
# from covidops_utils import preprocessAUDIO, preprocessIMG
import os
import sys
import urllib.request
from werkzeug.utils import secure_filename
import pandas as pd
import numpy as np
import librosa
from joblib import dump, load
import keras
import matplotlib.pyplot as plt
import cv2
import soundfile as sf
import tensorflow as tf
from keras.models import load_model

#Features to be extracted
features =  [
                'chroma_stft', 'rmse', 'spectral_centroid', 'spectral_bandwidth', 'rolloff', 'zero_crossing_rate',
                'mfcc1', 'mfcc2', 'mfcc3', 'mfcc4', 'mfcc5', 'mfcc6', 'mfcc7', 'mfcc8', 'mfcc9', 'mfcc10', 
                'mfcc11', 'mfcc12', 'mfcc13', 'mfcc14', 'mfcc15', 'mfcc16', 'mfcc17', 'mfcc18', 'mfcc19', 'mfcc20'
            ]

# loading normalizer
scaler = load('std_scaler.bin')

app = Flask(__name__)

UPLOAD_FOLDER = 'static/uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

ALLOWED_EXTENSIONS_AUDIO = {'wav', 'mp3'}
ALLOWED_EXTENSIONS_IMAGE = {'png', 'jpg', 'jpeg'}
def allowed_file_audio(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_AUDIO
def allowed_file_image(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_IMAGE

def preprocessIMG(path):
    image1 = plt.imread(path)
    image1 = cv2.resize(image1, (224, 224))
    image1 = cv2.cvtColor(image1, cv2.COLOR_BGR2RGB)
    images = []
    images.append(image1)
    #images = np.array(images) / 255.0
    return images

def preprocessAUDIO(fn_wav):
    y, sr = librosa.load(fn_wav, mono=True, duration=3)
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

    return X_test

classes = ['Covid', 'Non-Covid']
#classes = ['Non-Covid', 'Covid']

interAud = tf.lite.Interpreter(model_path="model_tflite_tabular_audio.tflite")
interAud.allocate_tensors()
input_details_aud = interAud.get_input_details()
output_details_aud = interAud.get_output_details()
input_shape_aud = input_details_aud[0]['shape']

interImg = tf.lite.Interpreter(model_path="model.tflite")
interImg.allocate_tensors()
input_details_img = interImg.get_input_details()
output_details_img = interImg.get_output_details()
input_shape_img = input_details_img[0]['shape']

@app.route('/')
def main():
    return 'Homepage'
 
@app.route('/image', methods=['POST'])
def get_image():
    respdict = {}
    if 'file' not in request.files:
        respdict["prediction"] = "No file found"
        respdict["status"] = 300
        print(respdict, file=sys.stderr)
        resp = jsonify(respdict)
        resp.status_code = 200
        return resp

    f = request.files['file']

    if not allowed_file_image(f.filename):
        respdict["prediction"] = "File extension is invalid"
        respdict["status"] = 400
        print(respdict, file=sys.stderr)
        resp = jsonify(respdict)
        resp.status_code = 200
        return resp

    f.save(secure_filename(f.filename))
    try:
        listed = preprocessIMG(f.filename)
        #respdict["dataImg"] = preprocessIMG(r'test.jfif').tolist()
        #-------------------------------------------------------------------------------------------------------
        input_data = np.array(listed, dtype=np.float32) / 255.0
        interImg.set_tensor(input_details_img[0]['index'], input_data)
        interImg.invoke()
        output_data = interImg.get_tensor(output_details_img[0]['index'])
        predicted = classes[int(np.round(output_data[0][0]))]
        print(output_data[0][0], predicted, file=sys.stderr)
        #-------------------------------------------------------------------------------------------------------
        respdict["prediction"] = str(output_data[0][0])
        respdict["status"] = 200
        respdict["output"] = json.dumps(str(output_data[0][0]))
        if os.path.exists(f.filename):
            os.remove(f.filename)
        resp = jsonify(respdict)
        resp.status_code = 200
        print(respdict, file=sys.stderr)
        return resp
    except:
        if os.path.exists(f.filename):
            os.remove(f.filename)
        respdict["prediction"] = "Some error occured"
        respdict["status"] = 500
        print(respdict, file=sys.stderr)
        resp = jsonify(respdict)
        resp.status_code = 200
        return resp
    
@app.route('/audio', methods=['POST'])
def get_audio():
    respdict = {}
    if 'file' not in request.files:
        respdict["prediction"] = "No file found"
        respdict["status"] = 300
        print(respdict, file=sys.stderr)
        resp = jsonify(respdict)
        resp.status_code = 200
        return resp

    f = request.files['file']

    if not allowed_file_audio(f.filename):
        respdict["prediction"] = "File extension is invalid"
        respdict["status"] = 400
        print(respdict, file=sys.stderr)
        resp = jsonify(respdict)
        resp.status_code = 200
        return resp

    f.save(secure_filename(f.filename))
    try:
        listed = preprocessAUDIO(f.filename)
        #respdict["dataAud"] = preprocessAUDIO(r'pos-0421-084-cough-m-50-2.wav').tolist()
        #-------------------------------------------------------------------------------------------------------
        input_data = np.array(listed, dtype=np.float32)
        interAud.set_tensor(input_details_aud[0]['index'], input_data)
        interAud.invoke()
        output_data = interAud.get_tensor(output_details_aud[0]['index'])
        predicted = classes[int(np.round(output_data[0][0]))]
        print(output_data[0][0], file=sys.stderr)
        #-------------------------------------------------------------------------------------------------------
        respdict["prediction"] = str(output_data[0][0])
        respdict["status"] = 200
        if os.path.exists(f.filename):
            os.remove(f.filename)
        resp = jsonify(respdict)
        resp.status_code = 200
        print(respdict, file=sys.stderr)
        return resp
    except:
        if os.path.exists(f.filename):
            os.remove(f.filename)
        respdict["prediction"] = "Some error occured"
        respdict["status"] = 500
        resp = jsonify(respdict)
        resp.status_code = 200
        print(respdict, file=sys.stderr)
        return resp


#if __name__ == '__main__':
   #app.run(host='0.0.0.0', port='5000', debug=True)