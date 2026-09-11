# Jednorázové nastavení pro každého člena týmu

## Co musí člen udělat

Člen nejdřív nainstaluje a spustí Codex desktop. Potom vytvoří jeden dočasný úvodní chat, vloží do něj jediný prompt uvedený níže a řídí se jeho pokyny. Nemusí ručně instalovat Git ani GitHub CLI nebo klonovat repozitář.

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
9. Nad touto lokální složkou vytvoř právě jeden trvalý chat `Projekt 1 – Git ovládání` pro povely `začínám`, `záloha` a `končím`. Nevytvářej zálohovací chat ani hodinovou či jinou automatizaci.
10. Pokud na tomto počítači už existuje stará automatizace hodinového zálohování tohoto projektu, ukaž mi její přesný název a požádej mě o jediné potvrzení jejího vypnutí. Po potvrzení ji vypni nebo odstraň; jiné automatizace neměň.
11. Ověř, že trvalý chat používá správný lokální repozitář a že GitHub přihlášení i push oprávnění fungují. Read-only test nesmí vytvořit commit, push ani pull request.
12. Nakonec mi napiš krátký výsledek každé kontroly, přesnou cestu projektu, nalezenou cestu a verzi Godotu 4, aktivní GitHub účet a název trvalého chatu. Zelené potvrzení dej pouze tehdy, když je vše opravdu připravené. Při problému aktivuj bezpečnostní zámek podle `AGENTS.md` a uveď právě jeden bezpečný krok k nápravě.
```

Po úspěšném dokončení může člen úvodní instalační chat archivovat. Pro každodenní práci používá pouze chat `Projekt 1 – Git ovládání`.

## Každodenní použití

Před prací člen v chatu `Projekt 1 – Git ovládání` napíše pouze:

```text
začínám
```

Codex se zeptá, na čem bude člen pracovat a zda chce začít z aktuálního `main`, nebo pokračovat z konkrétní existující větve. Pracovat v Godotu začne až po zeleném potvrzení Codexu.

Pokud Codex při `začínám` najde zapomenuté změny, nejdřív je uloží do jediného lokálního commitu na nové větvi `rescue/...`. Potom nabídne jejich push na GitHub, ponechání pouze lokálně a čistý začátek z `main`, nebo pokračování v zachráněné práci. Rescue větev automaticky nemaže ani neslučuje.

Během delší práce může člen kdykoli napsat:

```text
záloha
```

Codex vytvoří kontrolovaný záložní commit a pushne pouze aktivní pracovní větev. Pull request při tomto povelu nevytváří.

Na konci člen uloží projekt v Godotu a napíše:

```text
končím
```

Codex vytvoří závěrečný commit, push a pull request do `main`, ale nikdy jej nesloučí. Pull request zkontroluje a sloučí vlastník nebo jiný schválený člen.

Hodinové automatické zálohování se nepoužívá. Změny se ukládají při ručním povelu `záloha`, při `končím` nebo jako bezpečný rescue commit při příštím `začínám`.
