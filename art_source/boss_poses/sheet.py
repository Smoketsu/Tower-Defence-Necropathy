import sys; from PIL import Image
ks=sys.argv[2:]; out=sys.argv[1]
ims=[Image.open(f"/home/user/gw_shots/boss_poses/{k}.png") for k in ks]
W=max(i.width for i in ims)*2 if len(ims)>1 else ims[0].width
cols=2; rows=(len(ims)+1)//2; cw=max(i.width for i in ims); ch=max(i.height for i in ims)
s=Image.new("RGB",(cols*cw,rows*ch),(40,40,48))
for i,im in enumerate(ims): s.paste(im,((i%2)*cw,(i//2)*ch))
s.save(out)
