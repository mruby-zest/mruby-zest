Widget {
    TextScroll {
        label:  {
            l  = ""
            l << "ZynAddSubFX is a powerful open source software synthesizer\n"
            l << "Zyn-Fusion is the completely rewritten interface for ZynAddSubFX's 3.0.0 Release\n"
            l << "\n"
            l << "Maintainer (2009-2016):\n"
            l << "    Mark McCurry\n"
            l << "\n"
            l << "Maintainer (2002-2010):\n"
            l << "    Nasca Octavian Paul\n"
            l << "\n"
            l << "3.0.0 UI & Icon Design:\n"
            l << "    Budislav Stepanov\n"
            l << "\n"
            l << "Contributors:\n"
            l << "    Hans Petter Selasky (BSD Compat)\n"
            l << "    Christopher Oliver (Unison + presets fix, mousewheel support,\n"
            l << "                        SUBnote overtones, unison enhancements, ...)\n"
            l << "    Gerald Folcher (legato, mono notes memory)\n"
            l << "    Lars Luthman (zombie fix,jack midi, LASH support)\n"
            l << "    Daniel Clemente (with a workaround of X11 repeated key bug)\n"
            l << "    Emmanuel Saracco (fix for JACK output)\n"
            l << "    Achim Settelmeier (QUERTZ keyboard layout for virtual keyboard)\n"
            l << "    Jérémie Andréi (AZERTY keyboard layout, Array index fix, OSS failsafe)\n"
            l << "    Alexis Ballier (const char* <-> string mismatch, NULLMidi prototype fix)\n"
            l << "    Tobias Doerffel (static-instance variables fix, missing include fix)\n"
            l << "    James Morris (Memory leaks in FLTK GUI)\n"
            l << "    Alan Calvert (Portions of New IO)\n"
            l << "    Stephen Parry (DSSI rebuild)\n"
            l << "    Ryan Billing (APhaser)\n"
            l << "    Hans Petter Selasky (OSS Midi, FreeBSD support, Bank UI bug fix)\n"
            l << "    Damien Goutte-Gattat (Bank select midi support)\n"
            l << "    Lieven Moors (Spike/Circle waveform)\n"
            l << "    Olaf Schulz (MIDI Aftertouch support)\n"
            l << "    Jonathan Liles (NSM & NTK support)\n"
            l << "    Johannes Lorenz (Effect Documentation, PID Files, Testing Extrodanare)\n"
            l << "    Ilario Glasgo (Italian Doc Translation)\n"
            l << "    Filipe Coelho (Globals Cleanup, LV2/VST Support)\n"
            l << "    Andre Sklenar (UI Pixmaps)\n"
            l << "    Harald Hvaal (General Code Modernization)\n"
            l << "    Olivier Jolly (DSSI Bank Load Fix)\n"
            l << "\n"
            l << "This is the 3.0.0 version of ZynAddSubFX\n"
            l << "For more information please see http://zynaddsubfx.sourceforge.net/\n"
            l
        }
    }

    function draw(vg) {
        vg.path do |v|
            v.rect(0,0,w,h)
            paint = v.linear_gradient(0,0,0,h,
            Theme::InnerGrad1, Theme::InnerGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_color color(:black)
            v.stroke_width 1.0
            v.stroke
        end
    }
}
