class MugshotWindow < SpriteWindow_Base
  def initialize(face)
    super(0, 0, 128, 128)
    self.windowskin=nil
	self.skinrect=Rect.new(0, 0, 0, 0)
    faceinfo = face.split(",")
    facefile=pbResolveBitmap(MugshotsSettings::MUGSHOTS_FOLDER + faceinfo[0])
	self.contents&.dispose
    @facebitmap=AnimatedBitmap.new(facefile)
    self.contents=@facebitmap&.bitmap
	self.width = self.borderX + (@facebitmap&.bitmap&.width || 96)
    self.height = self.borderY + (@facebitmap&.bitmap&.height || 96)
	self.endX=self.width
	self.endY=self.height
	self.contents_opacity = MugshotsSettings::DISABLED_OPACITY if faceinfo[1] == 'D'
  end
 
  def borderY
    return MugshotsSettings::MUGSHOTS_BORDER_Y
  end
  
  def update
    super
    if @facebitmap.totalFrames>1
      @facebitmap.update
      self.contents=@facebitmap&.bitmap
    end
  end
 
  def dispose
    @facebitmap&.dispose
    super
  end
end         