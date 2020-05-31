from pynput import keyboard
import time

print("---------------- BPM Measurement Tool ----------------")
print("\n------------ Usage ------------")
print("esc - reset (esc twice to exit)")
print("space - track a beat")
print("-------------------------------\n")

def print_bpm(bpm, time_remaining):
    print("BPM: " + str(round(bpm, 2)) + "\t" + "Time remaining: " + str(round(time_remaining/1000,1)) + "\t", end="\r")

exit_program = False
completed = False
timer_running = False
time_last_beat = 0
end_time = 0
bpm_values = []

def on_press(key):
    global exit_program, completed, timer_running, time_last_beat, end_time, bpm_values
    if key == keyboard.Key.esc:
        if(timer_running):
            timer_running = False
        elif (completed):
            completed = False
        else:
            exit_program = True
            return False  #stop listener

    if key == keyboard.Key.space:
        if(timer_running):
            time_beat = time.time_ns()/1e6
            bpm_values.append(1000/(time_beat-time_last_beat))
            time_last_beat = time_beat
            print_bpm(60*sum(bpm_values)/len(bpm_values), (end_time - time_beat))
        elif (not completed):
            timer_running = not completed
            time_last_beat = time.time_ns()/1e6
            end_time = time.time_ns()/1e6 + 6e4
            bpm_values = []
            print("BPM: reset\t" + "Time remaining: reset\t", end="\r")



listener = keyboard.Listener(on_press=on_press)
listener.start()  #start to listen on a separate thread
#listener.join()  #remove if main thread is polling self.keys

while(not exit_program):
    if(time_last_beat > end_time and timer_running):
        completed = True
        print("BPM: " + str(round(60*sum(bpm_values)/len(bpm_values), 2)) + "\t" + "Time remaining: 0.0" + "\t\n")
        print("Completed\n\nPress Esc to calculated again...", end='\r')
        timer_running = False
print("Program Terminated")