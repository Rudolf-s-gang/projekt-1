# Jednorázové nastavení pro každého člena týmu

## 1. Instalace a přihlášení

Každý potřebuje Godot 4.4, Git, GitHub CLI a Codex desktop. Používá vlastní GitHub účet.

```bash
git config --global user.name "Jméno člena"
git config --global user.email "github-email@example.com"
gh auth login -h github.com
gh auth status
```

Vlastník musí člena pozvat do soukromého repozitáře a člen musí pozvánku přijmout.

## 2. Klonování

```bash
gh repo clone Rudolf-s-gang/projekt-1
cd projekt-1
```

Člen otevře tuto složku v Godotu i v Codexu jako hlavní lokální projekt.

## 3. Jednorázový prompt pro Codex

```text
Tento chat bude trvalý řídicí chat pro zálohování projektu Projekt 1. Přečti kompletně AGENTS.md a nastav tento lokální projekt pro jednoduché povely „začínám“ a „končím“. Ověř Git, origin, GitHub přihlášení, oprávnění a Godot.

Zruš případnou samostatnou automatizaci tohoto projektu, která při každém běhu vytváří nový chat. Místo ní naplánuj každých 60 minut pokračování přímo v tomto existujícím chatu. Automatizace musí pracovat přímo v lokálním projektu, ne ve worktree, a provádět přesně postup „Automatický checkpoint“ z AGENTS.md.

Pokud .git/ai-work-session neexistuje, nic neměň a neposílej běžné hlášení. Při úspěšném checkpointu napiš maximálně jeden krátký řádek s časem a hashem commitu. Pokud nejsou změny, nevypisuj zbytečné shrnutí. Při jakémkoliv problému aktivuj bezpečnostní zámek.

Nikdy neprováděj merge, rebase, force push, reset --hard, stash ani commit nebo push do main. Použij co nejomezenější oprávnění. Nic teď necommituj ani nepushuj. Nakonec proveď bezpečný test, ověř, že automatizace nevytváří nové chaty, a řekni, kdy proběhne první automatická kontrola.
```

## 4. Každodenní použití

Před prací člen napíše pouze:

```text
začínám
```

Codex se následně zeptá, na čem bude člen pracovat a zda chce začít z aktuálního `main`, nebo pokračovat z konkrétní existující větve. Pracovat v Godotu začne až po zeleném potvrzení Codexu. Na konci uloží projekt v Godotu a napíše:

```text
končím
```

Codex vždy vytvoří závěrečný commit, push a pull request do `main`, ale nikdy jej nesloučí. Pull request zkontroluje a sloučí vlastník nebo jiný schválený člen.

## Omezení automatických záloh

Lokální checkpoint proběhne jen při zapnutém počítači, běžící desktopové aplikaci, dostupném projektu a platném GitHub přihlášení. Codex nemůže zabránit otevření Godotu, ale při zjištěném problému nesmí potvrdit bezpečný začátek ani provést Git operace.
