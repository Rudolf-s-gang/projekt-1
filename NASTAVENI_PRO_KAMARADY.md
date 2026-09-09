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

## 3. Dva trvalé chaty v Codexu

Každý člen používá právě dva trvalé chaty nad stejnou lokální složkou projektu:

- `Projekt 1 – Git ovládání` pro povely `začínám` a `končím`,
- `Projekt 1 – automatické zálohování` pouze pro hodinovou automatizaci.

Oba chaty musí pracovat přímo ve stejné lokální složce naklonovaného projektu, ne v odděleném worktree. Automatizace se nepřenáší přes GitHub; každý člen ji musí jednou vytvořit na svém počítači.

V chatu `Projekt 1 – Git ovládání` vlož tento jednorázový prompt:

```text
Tento chat bude trvalý chat pro Git ovládání projektu Projekt 1. Přečti kompletně AGENTS.md a nastav tento lokální projekt pro jednoduché povely „začínám“ a „končím“. Ověř Git, očekávaný origin, GitHub přihlášení, identitu uživatele, oprávnění a Godot. Vždy pracuj přímo v tomto lokálním projektu, ne ve worktree.

Vytvoř právě jeden samostatný trvalý chat s názvem „Projekt 1 – automatické zálohování“ nad stejnou lokální složkou. Připoj k němu jednu hodinovou automatizaci. Automatizace musí pracovat přímo v lokálním projektu, ne ve worktree, a při každém běhu kompletně přečíst AGENTS.md. Nesmí při jednotlivých bězích vytvářet další chaty.

Pokud .git/ai-work-session existuje, prováděj pouze postup „Automatický checkpoint“. Pokud relace neexistuje, proveď pouze postup „Nouzová záloha bez aktivní relace“. Bez relace a bez změn okamžitě skonči bez hlášení. Nouzovou zálohu vždy ulož do právě jednoho commitu na nové větvi rescue/<github-uzivatel>/zapomenuta-relace-<YYYYMMDD-HHMMSS>; nikdy ji neukládej na main ani do původní větve a nevytvářej pro ni automaticky pull request.

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

Pokud člen zapomene napsat `začínám`, automatizace může bezpečně ověřené změny zachránit do jediného commitu na nové větvi `rescue/...`. Po upozornění už člen projekt neupravuje a požádá vlastníka o kontrolu. Codex záchrannou větev nikdy automaticky nesloučí ani z ní nevytvoří pull request.

## Omezení automatických záloh

Lokální checkpoint proběhne jen při zapnutém počítači, běžící desktopové aplikaci, dostupném projektu a platném GitHub přihlášení. Codex nemůže zabránit otevření Godotu, ale při zjištěném problému nesmí potvrdit bezpečný začátek ani provést Git operace.
