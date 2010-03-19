module TableSurgeon
  class SpeakerMock
    def initialize(id)
      @id = id
    end
    
    def id
      @id
    end
    
    def name
      "The name of the talk"
    end
  
    def image
      ""
    end
    
    def image_relative_path
      "images/rails.png"
    end
  
    def video_url
      "http://youtube.com"
    end
  end
end