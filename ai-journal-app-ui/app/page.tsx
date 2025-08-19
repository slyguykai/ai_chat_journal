"use client"

import { useState } from "react"
import { ChevronLeft, Menu, Bell, ChevronDown, X, ChevronRight, Heart, BookOpen, Lightbulb, Moon } from "lucide-react"
import { Button } from "@/components/ui/button"
import { MoodEmoji } from "@/components/mood-emoji"

export default function AIJournalApp() {
  const [currentScreen, setCurrentScreen] = useState<"home" | "mood" | "sleep" | "inspire" | "library">("home")

  const HomeScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-orange-200 via-orange-100 to-yellow-50 relative overflow-hidden">
      {/* Background decorative elements */}
      <div className="absolute top-20 right-4 w-32 h-32 bg-gradient-to-br from-pink-200/30 to-purple-200/30 rounded-full blur-xl"></div>
      <div className="absolute bottom-40 left-4 w-24 h-24 bg-gradient-to-br from-blue-200/30 to-cyan-200/30 rounded-full blur-lg"></div>

      {/* Status bar */}
      <div className="flex justify-between items-center px-6 pt-3 pb-2 text-sm font-medium">
        <span>9:41</span>
        <div className="w-24 h-6 bg-black rounded-full"></div>
        <div className="flex items-center gap-1">
          <div className="flex gap-1">
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black/50 rounded-full"></div>
          </div>
          <div className="w-6 h-3 border border-black rounded-sm">
            <div className="w-4 h-2 bg-black rounded-sm m-0.5"></div>
          </div>
        </div>
      </div>

      {/* Header */}
      <div className="flex justify-between items-center px-6 py-4">
        <Menu className="w-6 h-6" />
        <div className="bg-white/20 backdrop-blur-md border border-white/30 px-4 py-2 rounded-full flex items-center gap-2 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-105 transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)]">
          <span className="text-lg">🌟</span>
          <span className="font-medium">Good Evening</span>
        </div>
        <Bell className="w-6 h-6" />
      </div>

      {/* Streak section */}
      <div className="px-6 py-4">
        <div className="text-center mb-4">
          <div className="text-orange-500 text-sm font-medium mb-2">🔥 5 DAY STREAK</div>
          <div className="flex justify-center items-center gap-4 mb-2">
            <div className="text-center">
              <div className="mb-1 transform hover:scale-110 transition-transform duration-200">
                <MoodEmoji type="happy" size={32} />
              </div>
              <div className="text-xs text-gray-600">Fri</div>
            </div>
            <div className="text-center">
              <div className="mb-1 transform hover:scale-110 transition-transform duration-200">
                <MoodEmoji type="sad" size={32} />
              </div>
              <div className="text-xs text-gray-600">Sat</div>
            </div>
            <div className="text-center">
              <div className="mb-1 transform hover:scale-110 transition-transform duration-200">
                <MoodEmoji type="happy" size={32} />
              </div>
              <div className="text-xs text-gray-600">Sun</div>
            </div>
            <div className="text-center">
              <div className="mb-1 transform hover:scale-110 transition-transform duration-200">
                <MoodEmoji type="neutral" size={32} />
              </div>
              <div className="text-xs text-gray-600">Mon</div>
            </div>
            <div className="text-center">
              <div className="w-8 h-8 bg-white/30 backdrop-blur-md border border-white/40 rounded-full flex items-center justify-center mb-1 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-110 transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)]">
                <span className="text-orange-500 font-bold text-sm">19</span>
              </div>
              <div className="text-xs text-gray-600">Tue</div>
            </div>
          </div>
        </div>

        {/* Main content */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4 leading-tight">
            New Day
            <br />
            Fresh Start!
          </h1>
          <button className="bg-white/20 backdrop-blur-md border border-white/30 px-6 py-3 rounded-full text-gray-700 font-medium flex items-center gap-2 mx-auto shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-105 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)] transition-all duration-200">
            Begin Morning Preparation
            <ChevronRight className="w-4 h-4" />
          </button>
        </div>

        {/* Reflection card */}
        <div className="bg-gradient-to-br from-orange-300/60 to-orange-200/60 backdrop-blur-md border border-white/30 rounded-3xl p-6 mb-8 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-300 hover:shadow-[0_16px_48px_0_rgba(31,38,135,0.5)]">
          <p className="text-gray-800 font-medium mb-4 leading-relaxed">
            Are you the type of person who leaves reviews often?
          </p>
          <Button className="bg-gray-900 text-white px-6 py-2 rounded-full hover:bg-gray-800 shadow-[0_4px_16px_0_rgba(0,0,0,0.3)] transform hover:scale-105 transition-all duration-200 hover:shadow-[0_8px_24px_0_rgba(0,0,0,0.4)]">
            Reflect
          </Button>
        </div>
      </div>

      <div className="absolute bottom-0 left-0 right-0 bg-white/20 backdrop-blur-md border-t border-white/30 rounded-t-3xl">
        <div className="flex justify-around items-center py-2 px-4">
          <button
            onClick={() => setCurrentScreen("home")}
            className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "home" ? "opacity-100" : "opacity-60"}`}
          >
            <div
              className={`w-6 h-6 rounded mb-1 shadow-md ${currentScreen === "home" ? "bg-gray-900" : "bg-gray-300"}`}
            ></div>
            <span className={`text-xs ${currentScreen === "home" ? "font-medium text-gray-900" : "text-gray-500"}`}>
              Today
            </span>
          </button>
          <button
            onClick={() => setCurrentScreen("inspire")}
            className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "inspire" ? "opacity-100" : "opacity-60"}`}
          >
            <Lightbulb className={`w-6 h-6 mb-1 ${currentScreen === "inspire" ? "text-gray-900" : "text-gray-400"}`} />
            <span className={`text-xs ${currentScreen === "inspire" ? "font-medium text-gray-900" : "text-gray-500"}`}>
              Inspire
            </span>
          </button>
          <button
            onClick={() => setCurrentScreen("mood")}
            className="bg-gray-900 p-4 rounded-full -mt-6 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)] transform hover:scale-110 transition-all duration-300 hover:shadow-[0_12px_40px_0_rgba(0,0,0,0.4)]"
          >
            <div className="w-6 h-6 bg-white rounded-full"></div>
          </button>
          <button
            onClick={() => setCurrentScreen("library")}
            className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "library" ? "opacity-100" : "opacity-60"}`}
          >
            <BookOpen className={`w-6 h-6 mb-1 ${currentScreen === "library" ? "text-gray-900" : "text-gray-400"}`} />
            <span className={`text-xs ${currentScreen === "library" ? "font-medium text-gray-900" : "text-gray-500"}`}>
              Library
            </span>
          </button>
          <button
            onClick={() => setCurrentScreen("sleep")}
            className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "sleep" ? "opacity-100" : "opacity-60"}`}
          >
            <Moon className={`w-6 h-6 mb-1 ${currentScreen === "sleep" ? "text-gray-900" : "text-gray-400"}`} />
            <span className={`text-xs ${currentScreen === "sleep" ? "font-medium text-gray-900" : "text-gray-500"}`}>
              Sleep
            </span>
          </button>
        </div>
      </div>
    </div>
  )

  const MoodScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-pink-100 via-purple-50 to-pink-50 relative overflow-hidden">
      {/* Status bar */}
      <div className="flex justify-between items-center px-6 pt-3 pb-2 text-sm font-medium">
        <span>9:41</span>
        <div className="w-24 h-6 bg-black rounded-full"></div>
        <div className="flex items-center gap-1">
          <div className="flex gap-1">
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black/50 rounded-full"></div>
          </div>
          <div className="w-6 h-3 border border-black rounded-sm">
            <div className="w-4 h-2 bg-black rounded-sm m-0.5"></div>
          </div>
        </div>
      </div>

      {/* Header */}
      <div className="flex justify-between items-center px-6 py-4">
        <button onClick={() => setCurrentScreen("home")}>
          <ChevronLeft className="w-6 h-6" />
        </button>
        <div className="flex items-center gap-2">
          <span className="font-medium">Weeks</span>
          <ChevronDown className="w-4 h-4" />
        </div>
        <div className="w-6"></div>
      </div>

      {/* Content */}
      <div className="px-6 pb-24">
        <h1 className="text-4xl font-bold text-gray-900 mb-6">Good Mood</h1>

        <div className="flex items-center gap-2 mb-2 bg-white/20 backdrop-blur-md border border-white/30 rounded-full px-4 py-2 w-fit shadow-[0_8px_32px_0_rgba(31,38,135,0.37)]">
          <div className="w-6 h-6 flex items-center justify-center">
            <MoodEmoji type="happy" size={20} />
          </div>
          <span className="font-medium">3.6 average mood</span>
        </div>

        <p className="text-gray-600 text-sm mb-8">You focus on health and good meal</p>

        {/* Chart area */}
        <div className="mb-6">
          <div className="text-left mb-4">
            <span className="text-sm font-medium">Mood 3.7</span>
          </div>

          <div className="relative h-32 mb-4 bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)]">
            <svg className="w-full h-full" viewBox="0 0 300 120">
              <path
                d="M 20 80 Q 60 60 100 70 Q 140 50 180 60 Q 220 40 260 50"
                stroke="#a855f7"
                strokeWidth="3"
                fill="none"
                className="drop-shadow-sm"
              />
              <circle cx="100" cy="70" r="4" fill="#a855f7" className="drop-shadow-sm" />
            </svg>
          </div>

          {/* Week labels */}
          <div className="flex justify-between text-xs text-gray-500 mb-8">
            <span>S</span>
            <span>M</span>
            <span>T</span>
            <span>W</span>
            <span>T</span>
            <span>F</span>
            <span>S</span>
          </div>

          <div className="flex items-center gap-4 text-xs mb-8">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
              <span>This week</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-gray-300 rounded-full"></div>
              <span>Previous week</span>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4 mb-8">
          <div className="bg-gradient-to-br from-blue-200/60 to-cyan-200/60 backdrop-blur-md border border-white/30 rounded-3xl p-6 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-105 transition-all duration-300 hover:shadow-[0_16px_48px_0_rgba(31,38,135,0.5)]">
            <div className="text-gray-700 font-medium mb-2">Stress Level</div>
            <div className="text-gray-900 text-3xl font-bold">48%</div>
          </div>
          <div className="bg-gradient-to-br from-pink-200/60 to-rose-200/60 backdrop-blur-md border border-white/30 rounded-3xl p-6 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-105 transition-all duration-300 hover:shadow-[0_16px_48px_0_rgba(31,38,135,0.5)]">
            <div className="text-gray-700 font-medium mb-2">Sleep Quality</div>
            <div className="text-gray-900 text-3xl font-bold">5h</div>
          </div>
        </div>
      </div>

      <div className="absolute bottom-0 left-0 right-0 bg-white/20 backdrop-blur-md border-t border-white/30 rounded-t-3xl">
        <div className="flex justify-around items-center py-2 px-4">
          <button
            onClick={() => setCurrentScreen("home")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <div className="w-6 h-6 bg-gray-300 rounded mb-1"></div>
            <span className="text-xs text-gray-500">Today</span>
          </button>
          <button
            onClick={() => setCurrentScreen("inspire")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <Lightbulb className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Inspire</span>
          </button>
          <button
            onClick={() => setCurrentScreen("mood")}
            className="bg-gray-900 p-4 rounded-full -mt-6 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)] transform hover:scale-110 transition-all duration-300"
          >
            <div className="w-6 h-6 bg-white rounded-full"></div>
          </button>
          <button
            onClick={() => setCurrentScreen("library")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <BookOpen className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Library</span>
          </button>
          <button
            onClick={() => setCurrentScreen("sleep")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <Moon className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Sleep</span>
          </button>
        </div>
      </div>
    </div>
  )

  const SleepScreen = () => {
    const [selectedSleep, setSelectedSleep] = useState<"very-well" | "good" | "fair" | "poor">("fair")

    return (
      <div className="min-h-screen bg-gradient-to-br from-orange-100 via-peach-50 to-yellow-50 relative overflow-hidden">
        {/* Status bar */}
        <div className="flex justify-between items-center px-6 pt-3 pb-2 text-sm font-medium">
          <span>9:41</span>
          <div className="w-24 h-6 bg-black rounded-full"></div>
          <div className="flex items-center gap-1">
            <div className="flex gap-1">
              <div className="w-1 h-1 bg-black rounded-full"></div>
              <div className="w-1 h-1 bg-black rounded-full"></div>
              <div className="w-1 h-1 bg-black rounded-full"></div>
              <div className="w-1 h-1 bg-black/50 rounded-full"></div>
            </div>
            <div className="w-6 h-3 border border-black rounded-sm">
              <div className="w-4 h-2 bg-black rounded-sm m-0.5"></div>
            </div>
          </div>
        </div>

        {/* Header */}
        <div className="flex justify-between items-center px-6 py-4">
          <button onClick={() => setCurrentScreen("home")}>
            <ChevronLeft className="w-6 h-6" />
          </button>
          <div className="flex gap-1">
            <div className="w-2 h-2 bg-orange-400 rounded-full"></div>
            <div className="w-2 h-2 bg-gray-300 rounded-full"></div>
          </div>
          <button onClick={() => setCurrentScreen("home")}>
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Content */}
        <div className="px-6 pb-32">
          <h1 className="text-4xl font-bold text-gray-900 mb-6 leading-tight">
            How Well Did You
            <br />
            Sleep Today?
          </h1>

          <p className="text-gray-600 text-sm mb-12 leading-relaxed">
            We ask about your sleep so you can monitor it and improve its quality since good sleep is essential to
            healthy and prosperous life.
          </p>

          <div className="space-y-4 mb-12">
            <div className="flex items-center justify-between bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)]">
              <div>
                <div className="font-medium text-gray-900">Very Well</div>
                <div className="text-sm text-gray-600 flex items-center gap-2">
                  <span>⏰</span>
                  <span>7-8 hours</span>
                </div>
              </div>
              <div
                className={`w-6 h-6 rounded-full border-2 shadow-md ${selectedSleep === "very-well" ? "border-orange-400 bg-orange-400" : "border-gray-300"}`}
              ></div>
            </div>

            <div className="flex items-center justify-between bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)]">
              <div>
                <div className="font-medium text-gray-900">Good</div>
                <div className="text-sm text-gray-600">5-7 hours ⓘ</div>
              </div>
              <div
                className={`w-6 h-6 rounded-full border-2 shadow-md ${selectedSleep === "good" ? "border-orange-400 bg-orange-400" : "border-gray-300"}`}
              ></div>
            </div>

            <div className="flex items-center justify-between bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)]">
              <div>
                <div className="font-medium text-gray-900">Fair</div>
                <div className="text-sm text-gray-600 flex items-center gap-2">
                  <span>⏰</span>
                  <span>5 hours</span>
                </div>
              </div>
              <div className="relative">
                <div className="w-6 h-6 rounded-full border-2 border-orange-400 bg-orange-400 shadow-md"></div>
                <div className="absolute -right-8 top-1/2 transform -translate-y-1/2">
                  <div className="w-12 h-12 bg-orange-400 rounded-full flex items-center justify-center shadow-[0_8px_32px_0_rgba(255,165,0,0.4)] transform hover:scale-110 transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(255,165,0,0.6)]">
                    <div className="w-3 h-3 bg-white rounded-full"></div>
                  </div>
                </div>
              </div>
            </div>

            <div className="flex items-center justify-between bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200 hover:shadow-[0_12px_40px_0_rgba(31,38,135,0.5)]">
              <div>
                <div className="font-medium text-gray-900">Poor</div>
                <div className="text-sm text-gray-600">{"<3 hours ⓘ"}</div>
              </div>
              <div
                className={`w-6 h-6 rounded-full border-2 shadow-md ${selectedSleep === "poor" ? "border-orange-400 bg-orange-400" : "border-gray-300"}`}
              ></div>
            </div>
          </div>
        </div>

        <div className="absolute bottom-20 left-6 right-6">
          <button
            onClick={() => setCurrentScreen("home")}
            className="w-full bg-gray-900 text-white py-4 rounded-full font-medium flex items-center justify-center gap-3 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)] transform hover:scale-[1.02] hover:shadow-[0_16px_48px_0_rgba(0,0,0,0.4)] transition-all duration-300"
          >
            Continue
            <div className="w-8 h-8 bg-orange-400 rounded-full flex items-center justify-center shadow-[0_4px_16px_0_rgba(255,165,0,0.4)]">
              <ChevronRight className="w-4 h-4 text-white" />
            </div>
          </button>
        </div>

        {/* Bottom navigation */}
        <div className="absolute bottom-0 left-0 right-0 bg-white/20 backdrop-blur-md border-t border-white/30 rounded-t-3xl">
          <div className="flex justify-around items-center py-2 px-4">
            <button
              onClick={() => setCurrentScreen("home")}
              className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
            >
              <div className="w-6 h-6 bg-gray-300 rounded mb-1"></div>
              <span className="text-xs text-gray-500">Today</span>
            </button>
            <button
              onClick={() => setCurrentScreen("inspire")}
              className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
            >
              <Lightbulb className="w-6 h-6 text-gray-400 mb-1" />
              <span className="text-xs text-gray-500">Inspire</span>
            </button>
            <button
              onClick={() => setCurrentScreen("mood")}
              className="bg-gray-900 p-4 rounded-full -mt-6 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)] transform hover:scale-110 transition-all duration-300"
            >
              <div className="w-6 h-6 bg-white rounded-full"></div>
            </button>
            <button
              onClick={() => setCurrentScreen("library")}
              className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
            >
              <BookOpen className="w-6 h-6 text-gray-400 mb-1" />
              <span className="text-xs text-gray-500">Library</span>
            </button>
            <button
              onClick={() => setCurrentScreen("sleep")}
              className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "sleep" ? "opacity-100" : "opacity-60"}`}
            >
              <Moon className={`w-6 h-6 mb-1 ${currentScreen === "sleep" ? "text-gray-900" : "text-gray-400"}`} />
              <span className={`text-xs ${currentScreen === "sleep" ? "font-medium text-gray-900" : "text-gray-500"}`}>
                Sleep
              </span>
            </button>
          </div>
        </div>
      </div>
    )
  }

  const InspireScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-orange-50 relative overflow-hidden">
      {/* Background decorative elements */}
      <div className="absolute top-20 right-4 w-32 h-32 bg-gradient-to-br from-yellow-200/30 to-orange-200/30 rounded-full blur-xl"></div>
      <div className="absolute bottom-40 left-4 w-24 h-24 bg-gradient-to-br from-purple-200/30 to-pink-200/30 rounded-full blur-lg"></div>

      {/* Status bar */}
      <div className="flex justify-between items-center px-6 pt-3 pb-2 text-sm font-medium">
        <span>9:41</span>
        <div className="w-24 h-6 bg-black rounded-full"></div>
        <div className="flex items-center gap-1">
          <div className="flex gap-1">
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black/50 rounded-full"></div>
          </div>
          <div className="w-6 h-3 border border-black rounded-sm">
            <div className="w-4 h-2 bg-black rounded-sm m-0.5"></div>
          </div>
        </div>
      </div>

      {/* Header */}
      <div className="flex justify-between items-center px-6 py-4">
        <button onClick={() => setCurrentScreen("home")}>
          <ChevronLeft className="w-6 h-6" />
        </button>
        <div className="bg-white/20 backdrop-blur-md border border-white/30 px-4 py-2 rounded-full flex items-center gap-2 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)]">
          <Lightbulb className="w-4 h-4" />
          <span className="font-medium">Daily Inspiration</span>
        </div>
        <div className="w-6"></div>
      </div>

      {/* Content */}
      <div className="px-6 pb-24">
        <h1 className="text-4xl font-bold text-gray-900 mb-6">Find Your Spark</h1>

        <p className="text-gray-600 text-sm mb-8">
          Discover daily quotes, affirmations, and mindful moments to inspire your journey.
        </p>

        {/* Quote of the day */}
        <div className="bg-gradient-to-br from-purple-200/60 to-pink-200/60 backdrop-blur-md border border-white/30 rounded-3xl p-6 mb-6 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-300">
          <div className="text-center">
            <div className="text-4xl mb-4">✨</div>
            <p className="text-gray-800 font-medium text-lg mb-4 leading-relaxed">
              "The only way to do great work is to love what you do."
            </p>
            <p className="text-gray-600 text-sm">— Steve Jobs</p>
          </div>
        </div>

        {/* Affirmation cards */}
        <div className="space-y-4 mb-8">
          <div className="bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-br from-orange-300 to-yellow-300 rounded-full flex items-center justify-center">
                <Heart className="w-5 h-5 text-white" />
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Morning Affirmation</h3>
                <p className="text-sm text-gray-600">I am capable of amazing things today</p>
              </div>
            </div>
          </div>

          <div className="bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-300 to-cyan-300 rounded-full flex items-center justify-center">
                <span className="text-white text-lg">🌱</span>
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Growth Mindset</h3>
                <p className="text-sm text-gray-600">Every challenge is an opportunity to learn</p>
              </div>
            </div>
          </div>

          <div className="bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient-to-br from-green-300 to-emerald-300 rounded-full flex items-center justify-center">
                <span className="text-white text-lg">🧘</span>
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Mindful Moment</h3>
                <p className="text-sm text-gray-600">Take three deep breaths and center yourself</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom navigation */}
      <div className="absolute bottom-0 left-0 right-0 bg-white/20 backdrop-blur-md border-t border-white/30 rounded-t-3xl">
        <div className="flex justify-around items-center py-2 px-4">
          <button
            onClick={() => setCurrentScreen("home")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <div className="w-6 h-6 bg-gray-300 rounded mb-1"></div>
            <span className="text-xs text-gray-500">Today</span>
          </button>
          <button
            onClick={() => setCurrentScreen("inspire")}
            className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "inspire" ? "opacity-100" : "opacity-60"}`}
          >
            <Lightbulb className={`w-6 h-6 mb-1 ${currentScreen === "inspire" ? "text-gray-900" : "text-gray-400"}`} />
            <span className={`text-xs ${currentScreen === "inspire" ? "font-medium text-gray-900" : "text-gray-500"}`}>
              Inspire
            </span>
          </button>
          <button
            onClick={() => setCurrentScreen("mood")}
            className="bg-gray-900 p-4 rounded-full -mt-6 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)] transform hover:scale-110 transition-all duration-300"
          >
            <div className="w-6 h-6 bg-white rounded-full"></div>
          </button>
          <button
            onClick={() => setCurrentScreen("library")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <BookOpen className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Library</span>
          </button>
          <button
            onClick={() => setCurrentScreen("sleep")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <Moon className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Sleep</span>
          </button>
        </div>
      </div>
    </div>
  )

  const LibraryScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-100 via-indigo-50 to-purple-50 relative overflow-hidden">
      {/* Background decorative elements */}
      <div className="absolute top-20 right-4 w-32 h-32 bg-gradient-to-br from-indigo-200/30 to-purple-200/30 rounded-full blur-xl"></div>
      <div className="absolute bottom-40 left-4 w-24 h-24 bg-gradient-to-br from-blue-200/30 to-cyan-200/30 rounded-full blur-lg"></div>

      {/* Status bar */}
      <div className="flex justify-between items-center px-6 pt-3 pb-2 text-sm font-medium">
        <span>9:41</span>
        <div className="w-24 h-6 bg-black rounded-full"></div>
        <div className="flex items-center gap-1">
          <div className="flex gap-1">
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black rounded-full"></div>
            <div className="w-1 h-1 bg-black/50 rounded-full"></div>
          </div>
          <div className="w-6 h-3 border border-black rounded-sm">
            <div className="w-4 h-2 bg-black rounded-sm m-0.5"></div>
          </div>
        </div>
      </div>

      {/* Header */}
      <div className="flex justify-between items-center px-6 py-4">
        <button onClick={() => setCurrentScreen("home")}>
          <ChevronLeft className="w-6 h-6" />
        </button>
        <div className="bg-white/20 backdrop-blur-md border border-white/30 px-4 py-2 rounded-full flex items-center gap-2 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)]">
          <BookOpen className="w-4 h-4" />
          <span className="font-medium">My Library</span>
        </div>
        <div className="w-6"></div>
      </div>

      {/* Content */}
      <div className="px-6 pb-24">
        <h1 className="text-4xl font-bold text-gray-900 mb-6">Your Journey</h1>

        <p className="text-gray-600 text-sm mb-8">
          Explore your past reflections, insights, and personal growth over time.
        </p>

        {/* Stats overview */}
        <div className="grid grid-cols-2 gap-4 mb-8">
          <div className="bg-gradient-to-br from-blue-200/60 to-indigo-200/60 backdrop-blur-md border border-white/30 rounded-3xl p-6 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-105 transition-all duration-300">
            <div className="text-gray-700 font-medium mb-2">Total Entries</div>
            <div className="text-gray-900 text-3xl font-bold">47</div>
          </div>
          <div className="bg-gradient-to-br from-purple-200/60 to-pink-200/60 backdrop-blur-md border border-white/30 rounded-3xl p-6 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-105 transition-all duration-300">
            <div className="text-gray-700 font-medium mb-2">Streak Days</div>
            <div className="text-gray-900 text-3xl font-bold">12</div>
          </div>
        </div>

        {/* Recent entries */}
        <div className="mb-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Recent Reflections</h2>

          <div className="space-y-4">
            <div className="bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200">
              <div className="flex items-start justify-between mb-2">
                <div className="flex items-center gap-2">
                  <MoodEmoji type="happy" size={24} />
                  <span className="font-medium text-gray-900">Today's Reflection</span>
                </div>
                <span className="text-xs text-gray-500">2h ago</span>
              </div>
              <p className="text-sm text-gray-600 leading-relaxed">
                Feeling grateful for the small moments today. The morning coffee tasted especially good...
              </p>
            </div>

            <div className="bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200">
              <div className="flex items-start justify-between mb-2">
                <div className="flex items-center gap-2">
                  <MoodEmoji type="neutral" size={24} />
                  <span className="font-medium text-gray-900">Yesterday</span>
                </div>
                <span className="text-xs text-gray-500">1d ago</span>
              </div>
              <p className="text-sm text-gray-600 leading-relaxed">
                Had some challenges at work but managed to stay focused. Learning to be more patient...
              </p>
            </div>

            <div className="bg-white/20 backdrop-blur-md border border-white/30 rounded-2xl p-4 shadow-[0_8px_32px_0_rgba(31,38,135,0.37)] transform hover:scale-[1.02] transition-all duration-200">
              <div className="flex items-start justify-between mb-2">
                <div className="flex items-center gap-2">
                  <MoodEmoji type="love" size={24} />
                  <span className="font-medium text-gray-900">Sunday Thoughts</span>
                </div>
                <span className="text-xs text-gray-500">3d ago</span>
              </div>
              <p className="text-sm text-gray-600 leading-relaxed">
                Spent quality time with family. These moments remind me what truly matters in life...
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom navigation */}
      <div className="absolute bottom-0 left-0 right-0 bg-white/20 backdrop-blur-md border-t border-white/30 rounded-t-3xl">
        <div className="flex justify-around items-center py-2 px-4">
          <button
            onClick={() => setCurrentScreen("home")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <div className="w-6 h-6 bg-gray-300 rounded mb-1"></div>
            <span className="text-xs text-gray-500">Today</span>
          </button>
          <button
            onClick={() => setCurrentScreen("inspire")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <Lightbulb className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Inspire</span>
          </button>
          <button
            onClick={() => setCurrentScreen("mood")}
            className="bg-gray-900 p-4 rounded-full -mt-6 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)] transform hover:scale-110 transition-all duration-300"
          >
            <div className="w-6 h-6 bg-white rounded-full"></div>
          </button>
          <button
            onClick={() => setCurrentScreen("library")}
            className={`flex flex-col items-center py-2 transform hover:scale-105 transition-all duration-200 ${currentScreen === "library" ? "opacity-100" : "opacity-60"}`}
          >
            <BookOpen className={`w-6 h-6 mb-1 ${currentScreen === "library" ? "text-gray-900" : "text-gray-400"}`} />
            <span className={`text-xs ${currentScreen === "library" ? "font-medium text-gray-900" : "text-gray-500"}`}>
              Library
            </span>
          </button>
          <button
            onClick={() => setCurrentScreen("sleep")}
            className="flex flex-col items-center py-2 opacity-60 transform hover:scale-105 transition-all duration-200"
          >
            <Moon className="w-6 h-6 text-gray-400 mb-1" />
            <span className="text-xs text-gray-500">Sleep</span>
          </button>
        </div>
      </div>
    </div>
  )

  return (
    <div className="max-w-sm mx-auto bg-white rounded-[3rem] overflow-hidden shadow-2xl border-8 border-gray-900">
      {currentScreen === "home" && <HomeScreen />}
      {currentScreen === "mood" && <MoodScreen />}
      {currentScreen === "sleep" && <SleepScreen />}
      {currentScreen === "inspire" && <InspireScreen />}
      {currentScreen === "library" && <LibraryScreen />}
    </div>
  )
}
