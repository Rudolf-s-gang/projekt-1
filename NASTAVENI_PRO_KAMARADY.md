# Jednorázové nastavení pro každého člena týmu

## Co musí člen udělat

Člen nejdřív nainstaluje a spustí Codex desktop. Potom vytvoří jeden dočasný úvodní chat, vloží do něj jediný prompt uvedený níže a řídí se jeho pokyny. Nemusí ručně instalovat Git ani GitHub CLI, klonovat repozitář nebo nastavovat automatizaci.

Codex může během nastavení požádat o potvrzení instalace systémových balíčků, přihlášení ke GitHubu a výběr cílové složky. Tyto bezpečnostní a přihlašovací kroky musí člen potvrdit osobně; prompt je nesmí obcházet.

## Jediný instalační prompt

```text
Nastav mi kompletně lokální prostředí pro týmový Godot projekt Rudolf-s-gang/projekt-1. Proveď celý postup až do ověřeného výsledku a vysvětluj mi pouze kroky, u kterých musím něco potvrdit nebo dokončit osobně.

1. Nejdřív zjisti můj operační systém a read-only kontrolami ověř Git a GitHub CLI včetně jejich verzí. Nic systémového zatím neměň.
2. Pokud Git nebo GitHub CLI chybí, použij pouze instalační příkazy z aktuální oficiální dokumentace git-scm.com a cli.github.com vhodné pro můj systém. Před instalací systémových balíčků si vyžádej moje výslovné schválení. Nepoužívej neověřené instalační skripty.
3. Godot 4 už mám nainstalovaný. Nikdy jej neinstaluj, neaktualizuj, neodinstalovávej ani neměň systémový `PATH`. Pouze najdi existující spustitelný soubor: nejdřív zkontroluj `godot` a `godot4` v `PATH`, potom běžná umístění pro můj systém (na macOS také `/Applications/Godot.app/Contents/MacOS/Godot`, na Windows použij `Get-Command`, na Linuxu ověř i existující Flatpak). Neprohledávej bez omezení celý disk. Nalezený soubor ověř pomocí `--version` a přijmi libovolnou verzi řady Godot 4. Pokud jej nenajdeš, požádej mě o výběr aplikace nebo přesnou cestu; nic nestahuj.
4. Spusť interaktivní přihlášení `gh auth login -h github.com`. Nech mě dokončit přihlášení a potom pomocí `gh auth status` ověř aktivní účet. Nikdy nezobrazuj ani neukládej token. Ověř, že tento účet má přístup k repozitáři https://github.com/Rudolf-s-gang/projekt-1. Pokud přístup chybí, zastav se a řekni mi, že musím přijmout pozvánku od vlastníka.
5. Zeptej se mě na jméno a e-mail používaný pro Git commity a na cílovou nadřazenou složku. Jako výchozí složku nabídni `~/godot`. Pokud už cílová složka `projekt-1` existuje, nic nemaž ani nepřepisuj; nejdřív ověř, zda jde o správný čistý klon, jinak se zastav.
6. Naklonuj repozitář příkazem `gh repo clone Rudolf-s-gang/projekt-1 <zvolena-slozka>/projekt-1`. V naklonovaném repozitáři nastav `user.name` a `user.email` pouze lokálně, ne globálně. Absolutní cestu k ověřenému Godotu ulož do `.git/ai-local-config` jako `GODOT_EXECUTABLE=<absolutni-cesta>`; tento lokální soubor nikdy necommituj, nevkládej do něj žádné tajné údaje a nikdy jej nespouštěj ani nenačítej jako shellový skript. Cestu při spouštění bezpečně cituj, pokud obsahuje mezery. Ověř kořen repozitáře, čistý `git status --short`, větev `main`, remote `origin` a shodu lokálního `main` s `origin/main`. Nikdy nepoužívej force push, reset --hard, stash, merge ani rebase.
7. Kompletně přečti soubor `AGENTS.md` z naklonovaného repozitáře a od této chvíle dodržuj jeho pravidla. Ověř také `.gitignore`, aby se necommitovaly `.godot/`, buildy, exporty, tajné údaje ani lokální nastavení editoru.
8. Zajisti, aby Codex používal naklonovanou složku přímo jako lokální projekt, ne jako oddělený worktree. Pokud tuto změnu nelze udělat automaticky, dej mi právě jeden přesný krok v rozhraní Codexu, počkej na jeho dokončení a potom pokračuj.
9. Nad touto stejnou lokální složkou vytvoř právě dva trvalé chaty: `Projekt 1 – Git ovládání` pro povely `začínám` a `končím` a `Projekt 1 – automatické zálohování` pouze pro hodinové kontroly. Nevytvářej nový chat při každém automatickém běhu.
10. K zálohovacímu chatu připoj právě jednu aktivní automatizaci každých 60 minut. Při každém běhu musí nejdřív kompletně přečíst `AGENTS.md`. Pokud existuje `.git/ai-work-session`, provede pouze „Automatický checkpoint“. Pokud relace neexistuje, provede pouze „Nouzovou zálohu bez aktivní relace“. Bez relace a bez změn okamžitě skončí bez hlášení.
11. Nouzová záloha smí bezpečně ověřené změny uložit pouze do jednoho commitu na nové větvi `rescue/<github-uzivatel>/zapomenuta-relace-<YYYYMMDD-HHMMSS>`. Nikdy nesmí commitovat nebo pushovat do `main`, automaticky vytvářet rescue pull request ani cokoliv slučovat.
12. Ověř, že oba trvalé chaty používají stejný lokální repozitář, automatizace je pouze jedna, nevytváří další chaty a GitHub přihlášení i push oprávnění fungují. Test nesmí vytvořit běžný commit, push ani pull request.
13. Nakonec mi napiš krátký výsledek každé kontroly, přesnou cestu projektu, nalezenou cestu a verzi Godotu 4, aktivní GitHub účet, názvy obou chatů a čas první automatické kontroly. Zelené potvrzení dej pouze tehdy, když je vše opravdu připravené. Při problému aktivuj bezpečnostní zámek podle `AGENTS.md` a uveď právě jeden bezpečný krok k nápravě.
```

Po úspěšném dokončení může člen úvodní instalační chat archivovat. Pro každodenní práci používá pouze chat `Projekt 1 – Git ovládání`; automatický chat nechává běžet na pozadí.

## Každodenní použití

Před prací člen v chatu `Projekt 1 – Git ovládání` napíše pouze:

```text
začínám
```

Codex se zeptá, na čem bude člen pracovat a zda chce začít z aktuálního `main`, nebo pokračovat z konkrétní existující větve. Pracovat v Godotu začne až po zeleném potvrzení Codexu.

Na konci člen uloží projekt v Godotu a napíše:

```text
končím
```

Codex vytvoří závěrečný commit, push a pull request do `main`, ale nikdy jej nesloučí. Pull request zkontroluje a sloučí vlastník nebo jiný schválený člen.

Pokud člen zapomene napsat `začínám`, automatizace může bezpečně ověřené změny zachránit do jediného commitu na nové větvi `rescue/...`. Po upozornění už člen projekt neupravuje a požádá vlastníka o kontrolu. Codex záchrannou větev nikdy automaticky nesloučí ani z ní nevytvoří pull request.

## Omezení automatických záloh

Lokální checkpoint proběhne jen při zapnutém počítači, běžící desktopové aplikaci, dostupném projektu a platném GitHub přihlášení. Codex nemůže zabránit otevření Godotu, ale při zjištěném problému nesmí potvrdit bezpečný začátek ani provést Git operace.
