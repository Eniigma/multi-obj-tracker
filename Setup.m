function obj = Setup(videoFile)
        % Initialize Video I/O
        % Create objects for reading a video from a file, drawing the
        % detected and tracked people in each frame, and playing the video.

        % Create a video file reader.
%         obj.reader = vision.VideoFileReader(videoFile, 'VideoOutputDataType', 'uint8');
        obj.reader = VideoReader(videoFile);
        % Create a video player.
%         obj.videoPlayer = vision.VideoPlayer('Position', [29, 597, 643, 386]);
end