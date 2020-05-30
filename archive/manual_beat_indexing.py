import wave
import pyaudio
import time

#Global Variables
track_name = "fortroad_lost.wav"

#functions
def show_summary(ad):
    print("\tSUMMARY\n")
    print("-> Audio channels: " + str(ad.getnchannels()))
    print("-> Sample Size: " + str(ad.getsampwidth()) + " bytes")
    print("-> Sampling frequency: " + str(ad.getframerate()) + " samples per second\n")



#Read the track data
audio_data = wave.open(track_name, "rb") #Open audio file for reading
print("Track " + track_name + " loaded succesfully\n")
show_summary(audio_data)

audio = pyaudio.PyAudio().open(format = pyaudio.get_format_from_width(audio_data.getsampwidth()),
                                channels = audio_data.getnchannels(),
                                rate = audio_data.getframerate(),
                                input = False,
                                output = True)

audio.start_stream()
time.sleep(5)
audio.stop_stream()
audio.close()
