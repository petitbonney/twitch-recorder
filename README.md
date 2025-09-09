# Twitch Recorder
A script for Twitch Live recording.

#### Usage

```bash
record.sh -c <channel> -o <output_dir> [-q <crf>] [-p <preset>] [-t <oauth_token>]
  -c   Twitch channel name (required)
  -o   Output directory (default: /output)
  -q   CRF quality (default: 23)
  -p   x264 preset (default: veryfast)
  -t   Twitch OAuth token (optional)
```

#### Docker

```bash
docker build -t twitch-recorder .
docker run --rm -v .:/output twitch-recorder -c <channel>
```

#### Twitch Token

If you are subscribed to the channel or you have Twitch Turbo, you can avoid advertisements by passing your token.
To retrieve your token:
- Go to twitch.tv
- Connect to your account
- Open the dev tools
- Type ```document.cookie.split("; ").find(item=>item.startsWith("auth-token="))?.split("=")[1]``` in the console
