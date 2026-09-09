# Projekt 1 — pravidla pro Codex

Toto je společný projekt v Godotu 4.4. Členové týmu pracují v Godotu; Codex za ně bezpečně provádí synchronizaci, checkpoint commity, push a pull requesty.

## Jednorázová instalace Git a GitHub CLI

Pokud členovi chybí `git` nebo `gh`, Codex mu podle operačního systému zobrazí odpovídající příkazy níže. Instalaci systémových balíčků nikdy nespouštěj bez jeho výslovného souhlasu.

### macOS s Homebrew

```bash
brew install git gh
```

Pokud Homebrew není nainstalovaný, Git lze získat také pomocí nástrojů Applu:

```bash
xcode-select --install
```

GitHub CLI je potom stále potřeba nainstalovat samostatně, například přes Homebrew příkazem `brew install gh`.

### Windows v PowerShellu

```powershell
winget install --id Git.Git -e --source winget
winget install --id GitHub.cli -e --source winget
```

### Debian nebo Ubuntu

```bash
sudo apt update
sudo apt install git gh
```

Po instalaci vždy ověř oba nástroje a přihlas vlastní GitHub účet člena:

```bash
git --version
gh --version
gh auth login -h github.com
gh auth status
```

Pokud některý příkaz pro daný systém nefunguje, nic neobcházej neověřeným instalačním skriptem. Otevři aktuální oficiální návod na `https://git-scm.com/install/` nebo `https://cli.github.com/` a požádej uživatele o schválení dalšího postupu.

## Vyhledání existujícího Godotu 4

Godot 4 už je na počítači člena nainstalovaný. Nikdy jej neinstaluj, neaktualizuj, neodinstalovávej ani neměň systémovou proměnnou `PATH`. Pouze read-only kontrolami najdi jeho spustitelný soubor a ověř verzi pomocí `--version`.

- Nejdřív zkus příkazy dostupné v `PATH`, například `godot`, `godot4` nebo odpovídající příkaz zjištěný systémovým vyhledáváním.
- Na macOS zkontroluj také běžné umístění `/Applications/Godot.app/Contents/MacOS/Godot` a uživatelovu složku `Applications`.
- Na Windows použij `Get-Command` a běžná umístění aplikací. Na Linuxu ověř také existující instalaci přes správce balíčků nebo Flatpak, ale nic neinstaluj.
- Neprohledávej bez omezení celý disk. Pokud Godot nenajdeš v běžných umístěních, požádej uživatele, aby vybral aplikaci Godot nebo zadal přesnou cestu ke spustitelnému souboru.
- Po naklonování ulož absolutní cestu ke spustitelnému souboru do lokálního souboru `.git/ai-local-config` jako `GODOT_EXECUTABLE=<absolutni-cesta>`. Soubor nikdy necommituj, nevkládej do něj žádné tajné údaje, nikdy jej nespouštěj ani nenačítej jako shellový skript a před každým použitím ověř, že cesta stále ukazuje na Godot 4.
- Cestu z `.git/ai-local-config` používej pro všechny headless kontroly v tomto lokálním projektu a při spuštění ji bezpečně cituj i tehdy, když obsahuje mezery. Pokud soubor nebo program chybí, zopakuj read-only hledání. Pokud dostupná verze není řady Godot 4, aktivuj bezpečnostní zámek.

## Základní bezpečnost

- Nikdy nepoužívej `git push --force`, `git reset --hard` ani nepřepisuj historii.
- Nikdy nevytvářej běžný commit přímo na `main` a nikdy neslučuj pull request.
- Neprováděj žádný `git merge` ani `git rebase`, a to ani na pracovní větvi. Konflikty pouze diagnostikuj a předej vlastníkovi projektu.
- Nikdy nemaž, nestashuj ani nepřepisuj lokální změny bez výslovného souhlasu uživatele.
- Nikdy necommituj `.godot/`, buildy, exporty, `.env`, tokeny, hesla, klíče nebo lokální nastavení editoru.
- Před commitem zkontroluj `git status --short`, celý diff a staged diff. Stageuj pouze ověřené soubory explicitními cestami.
- Při konfliktu, podezřelém souboru nebo nesouvisejících změnách zastav Git operace a požádej o rozhodnutí.
- Mluv s uživatelem česky a Git vysvětluj jednoduše.

## Povel „začínám“

1. Nejdřív polož uživateli přesně dvě krátké otázky a před odpovědí neprováděj žádné Git změny:
   - `Na čem budeš pracovat? Napiš krátký popis změny.`
   - `Chceš začít z aktuálního main, nebo pokračovat z jiné existující větve? Pokud z jiné, napiš její název.`
2. Z popisu práce vytvoř krátký ASCII identifikátor. Použij jej v názvu nové větve a jako kontext pro názvy checkpointů, závěrečného commitu a pull requestu. Nevymýšlej obsah změny, který uživatel neuvedl.
3. Ověř kořen repozitáře, remote `origin`, přihlášení `gh auth status`, oprávnění a stav automatické úlohy. Spusť `git status --short`. Pokud existují lokální změny z předchozí práce, nic nepřepisuj a aktivuj bezpečnostní zámek.
4. Vždy spusť `git fetch origin`, ale během aktivní práce automaticky nemerguj ani nerebasuj `main` do pracovní větve.
5. Pokud uživatel zvolil `main`, spusť `git switch main` a `git pull --ff-only origin main`. Ověř shodu s `origin/main` a vytvoř větev `work/<github-uzivatel>/<popis>-<YYYYMMDD-HHMM>`.
6. Pokud uživatel zvolil existující větev, ověř její přesný název lokálně nebo na `origin`, přepni se na ni a aktualizuj ji pouze fast-forwardem z odpovídající vzdálené větve. Nevytvářej náhradní větev a nepřimíchávej do ní `main`. Pokud větev neexistuje nebo fast-forward nelze provést, aktivuj bezpečnostní zámek.
7. Vytvoř lokální stavový soubor `.git/ai-work-session` s názvem větve, popisem práce, zvolenou základní větví, časem začátku a časem posledního úspěšného checkpointu. Tento soubor nikdy necommituj.
8. Až po úspěchu všech kroků napiš: `✅ Pracovní větev je připravená a můžeš začít v Godotu.` Uveď také název větve a z jaké větve práce vychází.

## Automatický checkpoint

Naplánovaná úloha běží každých 60 minut přímo v lokálním projektu. Musí být připojená k jednomu samostatnému trvalému zálohovacímu chatu daného uživatele. Tento chat se používá pouze pro automatické kontroly a nesmí při každém běhu zakládat další chat.

1. Pokud `.git/ai-work-session` neexistuje, proveď pouze níže uvedený postup „Nouzová záloha bez aktivní relace“.
2. Ověř bezpečnostní podmínky níže a že aktuální větev odpovídá relaci a není `main`.
3. Pokud nejsou smysluplné změny, nevytvářej commit.
4. Prohlédni změny a spusť dostupnou Godot kontrolu pomocí cesty k existujícímu Godotu 4 zjištěné při nastavení. Godot nikdy kvůli kontrole neinstaluj ani neaktualizuj.
5. Vytvoř checkpoint commit `chore: checkpoint <kratky-popis-prace>` podle popisu uloženého v `.git/ai-work-session` a pushni pouze aktivní pracovní větev.
6. Aktualizuj čas posledního úspěšného checkpointu v `.git/ai-work-session`.
7. Nevytvářej při každém checkpointu nový pull request.
8. Při úspěchu napiš do zálohovacího chatu maximálně jeden krátký řádek s časem a hashem commitu. Pokud nejsou změny, nevypisuj zbytečné shrnutí.

## Nouzová záloha bez aktivní relace

Tento postup je výjimka pro případ, kdy člen týmu zapomněl před prací napsat `začínám`. Nesmí nahrazovat běžnou pracovní relaci.

1. Pokud `.git/ai-work-session` neexistuje, spusť nejdřív pouze read-only kontrolu `git status --short`. Pokud nejsou žádné smysluplné změny, okamžitě skonči bez dalších kontrol, změn a hlášení.
2. Pokud změny existují, ověř kořen repozitáře, očekávaný `origin`, `gh auth status`, absenci probíhajícího merge, rebase nebo cherry-picku a zkontroluj celý diff, seznam souborů a jejich velikosti.
3. Zastav postup při tajném, podezřelém, nesouvisejícím, ignorovaném, zakázaném nebo neočekávaně velkém souboru. Nikdy nezahrnuj `.godot/`, buildy, exporty, `.env`, tokeny, hesla, klíče ani lokální nastavení editoru.
4. Ověř, že Godot právě nezapisuje nekonzistentní soubory, a spusť dostupnou Godot kontrolu pomocí cesty k existujícímu Godotu 4 zjištěné při nastavení. Godot nikdy kvůli kontrole neinstaluj ani neaktualizuj.
5. Z aktuálního `HEAD` vytvoř novou větev `rescue/<github-uzivatel>/zapomenuta-relace-<YYYYMMDD-HHMMSS>`. Nikdy nouzově necommituj přímo na `main`, do původní pracovní větve ani do větve jiného člověka.
6. Explicitními cestami stageuj pouze ověřené související soubory. Všechny změny z tohoto jednoho nálezu ulož do právě jednoho commitu `chore: rescue changes without active session` a pushni pouze novou záchrannou větev.
7. Nevytvářej pull request ani `.git/ai-work-session` a záchrannou větev automaticky neslučuj. Původní historii zachovej.
8. Upozorni uživatele jedním krátkým řádkem s názvem větve a hashem commitu. Výslovně mu řekni, aby přestal upravovat projekt a požádal vlastníka o kontrolu záchranné větve.
9. Při jakékoli nejasnosti aktivuj bezpečnostní zámek a nic necommituj ani nepushuj.

## Povel „končím“

1. Ověř aktivní relaci, pracovní větev, GitHub přihlášení, remote, síť a oprávnění.
2. Zkontroluj změny a spusť dostupnou Godot kontrolu.
3. Pokud zbývají smysluplné změny, vytvoř výstižný commit podle skutečného diffu a popisu práce z `.git/ai-work-session` ve formátu `<typ>: <popis>`. Typy: `feat`, `fix`, `refactor`, `art`, `audio`, `docs`, `test`, `chore`.
4. Pushni pracovní větev.
5. Vždy pomocí `gh pr create` vytvoř pull request do `main`, nebo existující PR aktualizuj. PR vytvoř i tehdy, když je větev za `main`; tuto skutečnost uveď v poznámkách. Popis musí obsahovat `Co se změnilo`, `Jak bylo ověřeno` a `Rizika / poznámky`.
6. Pull request neslučuj.
7. Teprve po úspěšném pushi odstraň `.git/ai-work-session`.
8. Vrať výsledek kontrol, hash posledního commitu a odkaz na pull request.

## Aktualizace main a konflikty

- Během běžné aktivní práce prováděj `fetch`, ale automaticky nemerguj ani nerebasuj nové změny z `main` do pracovní větve. Tím uživateli neměň projekt pod rukama uprostřed práce.
- Nevydávej menší počet synchronizací za prevenci konfliktů: odklad může konflikt pouze přesunout na konec a zvětšit ho. U práce delší než jeden den nebo při změnách stejných scén upozorni uživatele, že je vhodná řízená synchronizace.
- `končím` vždy vytvoří PR bez automatického slučování `main` do pracovní větve. GitHub potom ukáže, zda lze PR sloučit čistě.
- Pokud PR nemá konflikt, vlastník jej může po kontrole sloučit metodou squash.
- Pokud PR konflikt má, neprováděj merge, rebase ani automatickou úpravu konfliktních souborů. Aktivuj bezpečnostní zámek.
- Pomocí read-only kontrol zjisti, které soubory se překrývají, a srozumitelně popiš rozdíl mezi pracovní větví a `origin/main`. U `.tscn`, `.tres` a `project.godot` výslovně upozorni na riziko poškození Godot scény nebo nastavení.
- Vrať vlastníkovi projektu název pracovní větve, odkaz na PR, seznam dotčených souborů a doporučený další postup. Samotné vyřešení a sloučení konfliktu musí provést vlastník nebo jiný výslovně pověřený člověk mimo tento automatický pracovní postup.
- Původní pracovní větev a její historii vždy zachovej beze změny.

## Bezpečnostní zámek

Zámek aktivuj, pokud platí alespoň jedna podmínka:

- projekt nebo Git repozitář není dostupný,
- `origin` chybí nebo ukazuje jinam než na společný repozitář,
- nefunguje GitHub přihlášení, síť, zápis nebo push,
- chybí `main`, lokální `main` nelze aktualizovat pomocí fast-forward nebo vznikl konflikt,
- uživatel pracuje na `main` během aktivní relace,
- aktuální větev neodpovídá `.git/ai-work-session`,
- automatická úloha je vypnutá, zmeškala běh nebo poslední úspěšný checkpoint je při aktivní relaci starší než 90 minut,
- objeví se tajný, podezřelý, nesouvisející nebo neočekávaně velký soubor,
- Godot nebo jiný proces právě zapisuje nekonzistentní soubory.

Při zámku zastav commit, push, pull i vytvoření PR. Nic nemaž, nestashuj a nepřepisuj. Zobraz:

`⛔ ZÁLOHOVÁNÍ NENÍ V BEZPEČNÉM STAVU`

Potom uveď problém, čas poslední úspěšné zálohy, zda jsou lokální změny zachované, a právě jeden bezpečný krok k nápravě. Dokud se problém nevyřeší, nikdy netvrď, že lze bezpečně začít nebo skončit.

Počítač ani aplikaci nelze kontrolovat, když jsou vypnuté. Po návratu proto vždy porovnej současný čas s posledním úspěšným checkpointem a při překročení 90 minut aktivuj zámek.
