interface MoodEmojiProps {
  type: "happy" | "sad" | "neutral" | "excited" | "love"
  size?: number
  className?: string
}

export function MoodEmoji({ type, size = 32, className = "" }: MoodEmojiProps) {
  const getEmojiPath = () => {
    switch (type) {
      case "happy":
        return (
          <g>
            <circle cx="12" cy="10" r="1.5" fill="currentColor" />
            <circle cx="20" cy="10" r="1.5" fill="currentColor" />
            <path d="M8 18s2-4 8-4 8 4 8 4" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" />
          </g>
        )
      case "sad":
        return (
          <g>
            <circle cx="12" cy="10" r="1.5" fill="currentColor" />
            <circle cx="20" cy="10" r="1.5" fill="currentColor" />
            <path
              d="M8 20s2-4 8-4 8 4 8 4"
              stroke="currentColor"
              strokeWidth="2"
              fill="none"
              strokeLinecap="round"
              transform="rotate(180 16 18)"
            />
          </g>
        )
      case "neutral":
        return (
          <g>
            <circle cx="12" cy="10" r="1.5" fill="currentColor" />
            <circle cx="20" cy="10" r="1.5" fill="currentColor" />
            <line x1="10" y1="18" x2="22" y2="18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
          </g>
        )
      case "excited":
        return (
          <g>
            <path d="M8 10s2-2 4-2 4 2 4 2" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" />
            <path d="M16 10s2-2 4-2 4 2 4 2" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" />
            <ellipse cx="16" cy="18" rx="6" ry="3" stroke="currentColor" strokeWidth="2" fill="none" />
          </g>
        )
      case "love":
        return (
          <g>
            <circle cx="12" cy="10" r="1.5" fill="currentColor" />
            <circle cx="20" cy="10" r="1.5" fill="currentColor" />
            <path d="M8 18s2-4 8-4 8 4 8 4" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" />
            <path d="M14 6c0-1.5 1-3 3-3s3 1.5 3 3-3 3-3 3-3-1.5-3-3z" fill="currentColor" />
            <circle cx="18" cy="4" r="1" fill="currentColor" />
          </g>
        )
      default:
        return null
    }
  }

  return (
    <div className={`inline-flex items-center justify-center ${className}`} style={{ width: size, height: size }}>
      <svg width={size} height={size} viewBox="0 0 32 32" className="text-gray-800">
        <circle cx="16" cy="16" r="15" stroke="currentColor" strokeWidth="2" fill="none" />
        {getEmojiPath()}
      </svg>
    </div>
  )
}
