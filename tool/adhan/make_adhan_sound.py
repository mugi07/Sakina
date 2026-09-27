"""Son des notifications de prière : début de l'adhan (« Allahu Akbar,
Allahu Akbar »), extrait de l'adhan à la manière marocaine récité par
Anas Tazi (fichier fourni par l'auteur de l'app, non versionné).

Usage (depuis la racine du projet) :
    pip install soundfile numpy
    python tool/adhan/make_adhan_sound.py "assets/Adhan/<fichier>.mp3"

Produit :
- android/app/src/main/res/raw/adhan_takbir.ogg (Vorbis, canal Android) ;
- ios/Runner/adhan_takbir.wav (PCM 16 bits : iOS limite les sons de
  notification à 30 s et aux formats aiff, wav ou caf).
"""
import sys

import numpy as np
import soundfile as sf

START_S = 0.7   # début de la voix
END_S = 14.9    # juste avant la phrase suivante (« Ash-hadu… », à 15,05 s)
FADE_OUT_S = 1.8  # l'écho s'éteint doucement
RATE = 22050    # voix : pas besoin de plus


def main(source: str) -> None:
    data, sr = sf.read(source, always_2d=True)
    mono = data.mean(axis=1)
    clip = mono[int(START_S * sr):int(END_S * sr)]
    # Rééchantillonnage simple (interpolation linéaire après moyenne glissante
    # anti-repliement) : suffisant pour une voix.
    k = max(1, int(round(sr / RATE)))
    smooth = np.convolve(clip, np.ones(k) / k, mode='same')
    t_old = np.arange(len(smooth)) / sr
    t_new = np.arange(int(len(smooth) * RATE / sr)) / RATE
    out = np.interp(t_new, t_old, smooth)
    fade_in = int(0.02 * RATE)
    out[:fade_in] *= np.linspace(0, 1, fade_in)
    fade = int(FADE_OUT_S * RATE)
    out[-fade:] *= np.linspace(1, 0, fade) ** 2
    out *= 0.89 / np.abs(out).max()  # crête à -1 dBFS
    sf.write('android/app/src/main/res/raw/adhan_takbir.ogg', out, RATE, format='OGG', subtype='VORBIS')
    sf.write('ios/Runner/adhan_takbir.wav', out, RATE, subtype='PCM_16')
    print(f'{len(out) / RATE:.1f} s')


if __name__ == '__main__':
    main(sys.argv[1])
