{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
  ];

  /*
    # After rebuild, install pi packages manually:

    pi install git:github.com/DietrichGebert/ponytail                # lazy/minimal coding, anti-over-engineering
    pi install npm:@ferologics/pi-extensions                        # pi extensions bundle (extra tools)
    pi install git:github.com/codexstar69/bug-hunter                # multi-agent bug/security hunting workflow
    pi install npm:pi-web-providers                                 # extra LLM/web providers
    pi install git:github.com/joelhooks/pi-tools                    # session search, linear tracker, TUI design
    pi install git:github.com/tintinweb/pi-gitnexus                 # code knowledge graph (impact analysis, refactor)
    pi install git:github.com/emilkowalski/skills                   # UI polish, animation, Apple design, Swift
    pi install git:github.com/Leonxlnx/taste-skill                  # anti-slop frontend/design skills
    pi install git:github.com/obra/superpowers                      # dev methodology: spec -> plan -> TDD via subagents
    pi install git:github.com/mattpocock/skills                     # engineering skills (review, triage, plan, PR)
    pi install git:github.com/anthropics/skills                     # official: docx/pdf/pptx/xlsx processing
    pi install git:github.com/mukul975/Anthropic-Cybersecurity-Skills # 818 security skills (offensive/defensive/forensics)
    pi install git:github.com/zhaoxuya520/reverse-skill             # reverse engineering / pentest / CTF router
    pi install git:github.com/bergside/awesome-design-skills        # 67 design-system styles (bento, brutalism, ...)

    # skills without a top-level skills/ dir (won't auto-discover as packages)
    git clone --depth 1 https://github.com/badlogic/pi-skills ~/.pi/agent/skills/pi-skills  # official pi skills (web search, browser, Google APIs)
    git clone --depth 1 https://github.com/nextlevelbuilder/ui-ux-pro-max-skill /tmp/uupm && cp -r /tmp/uupm/.claude/skills/* ~/.pi/agent/skills/  # UI/UX design intelligence
  */
}
