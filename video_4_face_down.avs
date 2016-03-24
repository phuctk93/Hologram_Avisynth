#Video Output
wB = 1440 #Width of final (output) video, unit PIXEL, you can set  640, 960, 1440, 1920, 2160 or 2880 (1)
hB = 1080 #Height of final (output) video, unit PIXEL, you can set 480, 720, 1080, 1440, 1920 or 2160 (2)
lB = 7242 #Length final video, unit FRAMES, open video with VirtualDub to get frames (3)
re = hB/2 #Resize input video to Square
pos = hB/2 #Position

#Video Input
#Chane pixel_type to "RGB32", "RGB24", "YV12", "YUY2" for type your video (4)
vTop = DirectShowSource("f.avi",audio=false).Turn180().Spline16Resize(re,re).ConvertToYUY2() #Front video
vBottom = DirectShowSource("b.avi",audio=false).Spline16Resize(re,re).ConvertToYUY2() #Back video
vRight = DirectShowSource("r.avi",audio=false).TurnLeft().Spline16Resize(re,re).ConvertToYUY2() #Right video
vLeft = DirectShowSource("l.avi",audio=false).TurnRight().Spline16Resize(re,re).ConvertToYUY2() #Left video

#Audio Source - Output (5)
au = DirectShowSource("music.mp3")

#Black background
blankFrame = BlankClip(length=lB, width=wB, height=hB, fps=30, color=$000000, pixel_type="YUY2")

#Layer
Layer1 = Layer(blankFrame, vBottom, op="lighten", level=256, x=(wB-pos)/2, y=pos)
Layer2 = Layer(Layer1, vTop, op="lighten", level=256, x=(wB-pos)/2, y=0)
Layer3 = Layer(Layer2, vRight, op="lighten", level=256, x=wB/2, y=(hB-pos)/2)
Layer4 = Layer(Layer3, vLeft, op="lighten", level=256, x=wB/2-pos, y=(hB-pos)/2)

#Final result - Output
AudioDub(Layer4,au)