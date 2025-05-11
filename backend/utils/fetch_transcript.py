from youtube_transcript_api import YouTubeTranscriptApi, TranscriptsDisabled, NoTranscriptFound

def fetchTranscript(video_id):
    try:
        transcript = YouTubeTranscriptApi.get_transcript(video_id, languages=['en'])
        merged_transcript = "\n".join(t['text'] for t in transcript)
        return merged_transcript
    except TranscriptsDisabled:
        raise ValueError("Transcripts are disabled for this video.")
    except NoTranscriptFound:
        raise ValueError("No transcript found for the given language(s).")
    except Exception as e:
        raise ValueError(f"An error occurred: {e}")

if __name__ == "__main__":
    video_id = "T-D1OfcDW1M"   # T-D1OfcDW1M
    # ask the user for the video ID
    video_id = input("Enter the YouTube video ID: ")
    if not video_id:
        print("No video ID provided.")
        exit(1)
    # fetch the transcript
    try:
        transcript = fetchTranscript(video_id)
        print(transcript)
    except ValueError as e:
        print(e)