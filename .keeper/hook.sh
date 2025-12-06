#!/bin/bash
# Keeper Git Hook

KEEPER_DIR=".keeper"
KEEPER_README_FILE=".keeper/README.md"
TASK_FILE=".keeper/agent-task.md"
CONFIG_FILE=".keeper/config.json"
TEMPLATE_FILE=".keeper/prompt-template.md"

if [ -f ".keeper/config.json" ]; then
    TRIGGER_MODE=interactive
    AUTO_COMMIT=true
    AGENT_NAME=cline
    AGENT_COMMAND_OVERRIDE=
    DEBUG_MODE=false

    if [ "" = "true" ]; then 
        echo "DEBUG: CONFIG_FILE path is .keeper/config.json"
        echo "DEBUG: Does config.json exist? yes"
        echo "DEBUG: AUTO_COMMIT is "
    fi
    
    FILES_TO_UPDATE=()
    while IFS= read -r line; do
        FILES_TO_UPDATE+=("")
    done < <(jq -r ".files_to_update[]" ".keeper/config.json")

    EXCLUDE_PATTERNS=()
    while IFS= read -r line; do
        EXCLUDE_PATTERNS+=("")
    done < <(jq -r ".exclude[]" ".keeper/config.json")
else
    TRIGGER_MODE="auto"
    AUTO_COMMIT="true"
    AGENT_NAME="cline"
    AGENT_COMMAND_OVERRIDE=""
    DEBUG_MODE="false"
    FILES_TO_UPDATE=("README.md" "docs/")
    EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
fi

# Get the full list of changed files
ALL_CHANGED_FILES=(.keeper/README.md
.keeper/hook.sh
install.sh)

# Filter out excluded files
FILES_TO_PROCESS=()
for file in ""; do
    is_excluded=false
    for pattern in ""; do
        if [[ "" == "" ]]; then
            is_excluded=true
            break
        fi
    done
    if [ "" = false ]; then
        FILES_TO_PROCESS+=("")
    fi
done

# If no files are left to process, exit
if [ 0 -eq 0 ]; then
    echo "Keeper: All changed files are in the exclude list. Skipping."
    exit 0
fi

echo "Keeper: Processing the following files:"
sleep 1
for file in ""; do
    echo "- "
done

# Get a diff of only the files to be processed
DIFF=diff --git a/.keeper/README.md b/.keeper/README.md
index 2fc3813..2e347da 100644
--- a/.keeper/README.md
+++ b/.keeper/README.md
@@ -7,6 +7,7 @@ Agent-powered documentation that stays in sync with your code.
 Edit `$CONFIG_FILE` to customize:
 - `trigger_mode`: "auto" or "interactive".
 - `auto_commit`: `true` or `false`.
+- `debug`: `true` or `false`.
 - `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`.
 - `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path.
 - `files_to_update`: A list of documentation files and directories to keep updated.
diff --git a/.keeper/hook.sh b/.keeper/hook.sh
index a1321fb..410b8b9 100755
--- a/.keeper/hook.sh
+++ b/.keeper/hook.sh
@@ -12,13 +12,13 @@ if [ -f ".keeper/config.json" ]; then
     AUTO_COMMIT=true
     AGENT_NAME=cline
     AGENT_COMMAND_OVERRIDE=
-    DEBUG_MODE=false # ADDED
+    DEBUG_MODE=false
 
-    if [ "" = "true" ]; then # ADDED
+    if [ "" = "true" ]; then 
         echo "DEBUG: CONFIG_FILE path is .keeper/config.json"
         echo "DEBUG: Does config.json exist? yes"
         echo "DEBUG: AUTO_COMMIT is "
-    fi # ADDED
+    fi
     
     FILES_TO_UPDATE=()
     while IFS= read -r line; do
@@ -49,7 +49,7 @@ FILES_TO_PROCESS=()
 for file in ""; do
     is_excluded=false
     for pattern in ""; do
-        if [[ "" ==  ]]; then
+        if [[ "" == "" ]]; then
             is_excluded=true
             break
         fi
@@ -73,235 +73,765 @@ done
 
 # Get a diff of only the files to be processed
 DIFF=diff --git a/.keeper/agent-task.md b/.keeper/agent-task.md
-index 2efd729..4a65d0e 100755
+index 4a65d0e..80e361c 100755
 --- a/.keeper/agent-task.md
 +++ b/.keeper/agent-task.md
-@@ -32,15 +32,100 @@ install.sh
+@@ -32,100 +32,68 @@ install.sh
  ## Code Changes:
  ```diff
  diff --git a/install.sh b/install.sh
--index 8262c15..473d481 100755
-+index 473d481..a3030e8 100755
+-index 473d481..a3030e8 100755
++index a3030e8..8038c15 100755
  --- a/install.sh
  +++ b/install.sh
--@@ -2,7 +2,6 @@
-+@@ -1,7 +1,7 @@
-+ #!/bin/bash
+ @@ -1,7 +1,7 @@
+  #!/bin/bash
   # Keeper Installer
   # Usage: curl -fsSL https://keeper.dev/install.sh | bash
-- 
---# adding arbitrary comment for changes
-+-
-++# CHASNGE
+--
+-+# CHASNGE
++-# CHASNGE
+++
   set -e
   
   echo "📚 Installing Keeper..."
-+@@ -33,20 +33,21 @@ CONFIG_FILE="$KEEPER_DIR/config.json"
+-@@ -33,20 +33,21 @@ CONFIG_FILE="$KEEPER_DIR/config.json"
++@@ -32,12 +32,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
++ CONFIG_FILE="$KEEPER_DIR/config.json"
+  TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
+  
+++echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+++echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+++
+  if [ -f "$CONFIG_FILE" ]; then
+--    TRIGGER_MODE=$(jq -r '.trigger_mode // "auto"' "$CONFIG_FILE")
+--    AUTO_COMMIT=$(jq -r '.auto_commit // true' "$CONFIG_FILE")
+--    AGENT_NAME=$(jq -r '.agent // "cline"' "$CONFIG_FILE")
+--    AGENT_COMMAND_OVERRIDE=$(jq -r '.agent_command // ""' "$CONFIG_FILE")
+--
+-+    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
+-+    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
+-+    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
+-+    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
+-+    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+-+    
++     TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
++     AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
++     AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
++     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
++-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+++    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
++     
+      FILES_TO_UPDATE=()
+      while IFS= read -r line; do
+-         FILES_TO_UPDATE+=("$line")
+--    done < <(jq -r '.files_to_update[]' "$CONFIG_FILE")
+-+    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")
+- 
+-     EXCLUDE_PATTERNS=()
+-     while IFS= read -r line; do
+-         EXCLUDE_PATTERNS+=("$line")
+--    done < <(jq -r '.exclude[]' "$CONFIG_FILE")
+-+    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
+- else
+-     TRIGGER_MODE="auto"
+-     AUTO_COMMIT="true"
+-@@ -98,6 +99,10 @@ else
++@@ -99,12 +102,12 @@ else
+      COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
+  fi
+  
+-+echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
+-+cat "$TEMPLATE_FILE" # ADDED DEBUG
+-+echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
+-+echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
++-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
++-cat "$TEMPLATE_FILE" # ADDED DEBUG
++-echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
++-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+++echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+++cat "$TEMPLATE_FILE" # Existing DEBUG
+++echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+++echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
+  PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
+- TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
++-TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+++TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
+  TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
+-@@ -127,13 +132,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
++ 
++ echo "$TASK_CONTENT" > "$TASK_FILE"
++@@ -132,13 +135,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+      echo ""
+      case "$AGENT_NAME" in
+          "cline")
+--            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
+-+            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
++-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
+              ;;
+          "aider")
+--            echo "  aider 'Read and complete the task in $TASK_FILE'"
+-+            echo "  aider \'Read and complete the task in $TASK_FILE\'"
++-            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+++            echo "  aider \'Read and complete the task in $TASK_FILE\''"
+              ;;
+          "claude")
+--            echo "  claude 'Read and complete the task in $TASK_FILE'"
+-+            echo "  claude \'Read and complete the task in $TASK_FILE\'"
++-            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+++            echo "  claude \'Read and complete the task in $TASK_FILE\''"
+              ;;
+          *)
+              echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
+-@@ -142,7 +147,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+-     echo ""
+-     echo "After the agent responds, it will update your docs automatically."
+-     echo ""
+--    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
+-+    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to \'auto\'."
+-     echo "Read $KEEPER_README_FILE for usage instructions"
+-     exit 0
+- fi
+-@@ -163,7 +168,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+-                 AGENT_COMMAND="claude {{TASK_FILE}}"
+-                 ;;
+-             *)
+--                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
+-+                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
+-                 exit 1
+-                 ;;
+-         esac
+-@@ -172,7 +177,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+-     FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
+- 
+-     echo ""
+--    echo " Keeper is calling the AI agent '$AGENT_NAME'. Please wait, this may take a few moments..."
+-+    echo " Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait, this may take a few moments..."
+-     echo ""
+-     eval "$FINAL_COMMAND"
+-     echo ""
+ ```
+diff --git a/.keeper/hook.sh b/.keeper/hook.sh
+index 2218ef1..a1321fb 100755
+--- a/.keeper/hook.sh
++++ b/.keeper/hook.sh
+@@ -2,140 +2,377 @@
+ # Keeper Git Hook
+ 
+ KEEPER_DIR=".keeper"
+-KEEPER_README_FILE="$KEEPER_DIR/README.md"
+-TASK_FILE="$KEEPER_DIR/agent-task.md"
+-CONFIG_FILE="$KEEPER_DIR/config.json"
+-TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
+-
+-echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+-echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+-
+-if [ -f "$CONFIG_FILE" ]; then
+-    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
+-    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
+-    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
+-    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
+-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
++KEEPER_README_FILE=".keeper/README.md"
++TASK_FILE=".keeper/agent-task.md"
++CONFIG_FILE=".keeper/config.json"
++TEMPLATE_FILE=".keeper/prompt-template.md"
++
++if [ -f ".keeper/config.json" ]; then
++    TRIGGER_MODE=interactive
++    AUTO_COMMIT=true
++    AGENT_NAME=cline
++    AGENT_COMMAND_OVERRIDE=
++    DEBUG_MODE=false # ADDED
++
++    if [ "" = "true" ]; then # ADDED
++        echo "DEBUG: CONFIG_FILE path is .keeper/config.json"
++        echo "DEBUG: Does config.json exist? yes"
++        echo "DEBUG: AUTO_COMMIT is "
++    fi # ADDED
+     
+     FILES_TO_UPDATE=()
+     while IFS= read -r line; do
+-        FILES_TO_UPDATE+=("$line")
+-    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")
++        FILES_TO_UPDATE+=("")
++    done < <(jq -r ".files_to_update[]" ".keeper/config.json")
+ 
+     EXCLUDE_PATTERNS=()
+     while IFS= read -r line; do
+-        EXCLUDE_PATTERNS+=("$line")
+-    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
++        EXCLUDE_PATTERNS+=("")
++    done < <(jq -r ".exclude[]" ".keeper/config.json")
+ else
+     TRIGGER_MODE="auto"
+     AUTO_COMMIT="true"
+     AGENT_NAME="cline"
+     AGENT_COMMAND_OVERRIDE=""
++    DEBUG_MODE="false"
+     FILES_TO_UPDATE=("README.md" "docs/")
+     EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
+ fi
+ 
+ # Get the full list of changed files
+-ALL_CHANGED_FILES=($(git diff HEAD~1 HEAD --name-only))
++ALL_CHANGED_FILES=(.keeper/agent-task.md
++.keeper/hook.sh
++install.sh)
+ 
+ # Filter out excluded files
+ FILES_TO_PROCESS=()
+-for file in "${ALL_CHANGED_FILES[@]}"; do
++for file in ""; do
+     is_excluded=false
+-    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
+-        if [[ "$file" == $pattern ]]; then
++    for pattern in ""; do
++        if [[ "" ==  ]]; then
+             is_excluded=true
+             break
+         fi
+     done
+-    if [ "$is_excluded" = false ]; then
+-        FILES_TO_PROCESS+=("$file")
++    if [ "" = false ]; then
++        FILES_TO_PROCESS+=("")
+     fi
+ done
+ 
+ # If no files are left to process, exit
+-if [ ${#FILES_TO_PROCESS[@]} -eq 0 ]; then
++if [ 0 -eq 0 ]; then
+     echo "Keeper: All changed files are in the exclude list. Skipping."
+     exit 0
+ fi
+ 
+ echo "Keeper: Processing the following files:"
+ sleep 1
+-for file in "${FILES_TO_PROCESS[@]}"; do
+-    echo "- $file"
++for file in ""; do
++    echo "- "
+ done
+ 
+ # Get a diff of only the files to be processed
+-DIFF=$(git diff HEAD~1 HEAD -- "${FILES_TO_PROCESS[@]}")
+-if [ -z "$DIFF" ]; then
++DIFF=diff --git a/.keeper/agent-task.md b/.keeper/agent-task.md
++index 2efd729..4a65d0e 100755
++--- a/.keeper/agent-task.md
+++++ b/.keeper/agent-task.md
++@@ -32,15 +32,100 @@ install.sh
++ ## Code Changes:
++ ```diff
++ diff --git a/install.sh b/install.sh
++-index 8262c15..473d481 100755
+++index 473d481..a3030e8 100755
++ --- a/install.sh
++ +++ b/install.sh
++-@@ -2,7 +2,6 @@
+++@@ -1,7 +1,7 @@
+++ #!/bin/bash
++  # Keeper Installer
++  # Usage: curl -fsSL https://keeper.dev/install.sh | bash
++- 
++--# adding arbitrary comment for changes
+++-
++++# CHASNGE
++  set -e
++  
++  echo "📚 Installing Keeper..."
+++@@ -33,20 +33,21 @@ CONFIG_FILE="$KEEPER_DIR/config.json"
+++ TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
+++ 
+++ if [ -f "$CONFIG_FILE" ]; then
+++-    TRIGGER_MODE=$(jq -r '.trigger_mode // "auto"' "$CONFIG_FILE")
+++-    AUTO_COMMIT=$(jq -r '.auto_commit // true' "$CONFIG_FILE")
+++-    AGENT_NAME=$(jq -r '.agent // "cline"' "$CONFIG_FILE")
+++-    AGENT_COMMAND_OVERRIDE=$(jq -r '.agent_command // ""' "$CONFIG_FILE")
+++-
++++    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
++++    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
++++    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
++++    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
++++    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
++++    
+++     FILES_TO_UPDATE=()
+++     while IFS= read -r line; do
+++         FILES_TO_UPDATE+=("$line")
+++-    done < <(jq -r '.files_to_update[]' "$CONFIG_FILE")
++++    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")
+++ 
+++     EXCLUDE_PATTERNS=()
+++     while IFS= read -r line; do
+++         EXCLUDE_PATTERNS+=("$line")
+++-    done < <(jq -r '.exclude[]' "$CONFIG_FILE")
++++    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
+++ else
+++     TRIGGER_MODE="auto"
+++     AUTO_COMMIT="true"
+++@@ -98,6 +99,10 @@ else
+++     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
+++ fi
+++ 
++++echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
++++cat "$TEMPLATE_FILE" # ADDED DEBUG
++++echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
++++echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+++ PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
+++ TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+++ TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
+++@@ -127,13 +132,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+++     echo ""
+++     case "$AGENT_NAME" in
+++         "cline")
+++-            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
++++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+++             ;;
+++         "aider")
+++-            echo "  aider 'Read and complete the task in $TASK_FILE'"
++++            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+++             ;;
+++         "claude")
+++-            echo "  claude 'Read and complete the task in $TASK_FILE'"
++++            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+++             ;;
+++         *)
+++             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
+++@@ -142,7 +147,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+++     echo ""
+++     echo "After the agent responds, it will update your docs automatically."
+++     echo ""
+++-    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
++++    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to \'auto\'."
+++     echo "Read $KEEPER_README_FILE for usage instructions"
+++     exit 0
+++ fi
+++@@ -163,7 +168,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+++                 AGENT_COMMAND="claude {{TASK_FILE}}"
+++                 ;;
+++             *)
+++-                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
++++                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
+++                 exit 1
+++                 ;;
+++         esac
+++@@ -172,7 +177,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+++     FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
+++ 
+++     echo ""
+++-    echo " Keeper is calling the AI agent '$AGENT_NAME'. Please wait, this may take a few moments..."
++++    echo " Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait, this may take a few moments..."
+++     echo ""
+++     eval "$FINAL_COMMAND"
+++     echo ""
++ ```
++diff --git a/.keeper/hook.sh b/.keeper/hook.sh
++index b735de9..2218ef1 100755
++--- a/.keeper/hook.sh
+++++ b/.keeper/hook.sh
++@@ -7,12 +7,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
++ CONFIG_FILE="$KEEPER_DIR/config.json"
 + TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
 + 
+++echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+++echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+++
 + if [ -f "$CONFIG_FILE" ]; then
-+-    TRIGGER_MODE=$(jq -r '.trigger_mode // "auto"' "$CONFIG_FILE")
-+-    AUTO_COMMIT=$(jq -r '.auto_commit // true' "$CONFIG_FILE")
-+-    AGENT_NAME=$(jq -r '.agent // "cline"' "$CONFIG_FILE")
-+-    AGENT_COMMAND_OVERRIDE=$(jq -r '.agent_command // ""' "$CONFIG_FILE")
-+-
-++    TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
-++    AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
-++    AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
-++    AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
-++    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
-++    
++     TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
++     AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
++     AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
++     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
++-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+++    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
++     
 +     FILES_TO_UPDATE=()
 +     while IFS= read -r line; do
-+         FILES_TO_UPDATE+=("$line")
-+-    done < <(jq -r '.files_to_update[]' "$CONFIG_FILE")
-++    done < <(jq -r ".files_to_update[]" "$CONFIG_FILE")
-+ 
-+     EXCLUDE_PATTERNS=()
-+     while IFS= read -r line; do
-+         EXCLUDE_PATTERNS+=("$line")
-+-    done < <(jq -r '.exclude[]' "$CONFIG_FILE")
-++    done < <(jq -r ".exclude[]" "$CONFIG_FILE")
-+ else
-+     TRIGGER_MODE="auto"
-+     AUTO_COMMIT="true"
-+@@ -98,6 +99,10 @@ else
++@@ -74,12 +77,12 @@ else
 +     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 + fi
 + 
-++echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
-++cat "$TEMPLATE_FILE" # ADDED DEBUG
-++echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
-++echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
++-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
++-cat "$TEMPLATE_FILE" # ADDED DEBUG
++-echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
++-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+++echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+++cat "$TEMPLATE_FILE" # Existing DEBUG
+++echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+++echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
 + PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
-+ TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
++-TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+++TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
 + TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
-+@@ -127,13 +132,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
++ 
++ echo "$TASK_CONTENT" > "$TASK_FILE"
++@@ -107,13 +110,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
 +     echo ""
 +     case "$AGENT_NAME" in
 +         "cline")
-+-            echo "  cline -m act 'Read and complete the task in $TASK_FILE'"
-++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
++-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
 +             ;;
 +         "aider")
-+-            echo "  aider 'Read and complete the task in $TASK_FILE'"
-++            echo "  aider \'Read and complete the task in $TASK_FILE\'"
++-            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+++            echo "  aider \'Read and complete the task in $TASK_FILE\''"
 +             ;;
 +         "claude")
-+-            echo "  claude 'Read and complete the task in $TASK_FILE'"
-++            echo "  claude \'Read and complete the task in $TASK_FILE\'"
++-            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+++            echo "  claude \'Read and complete the task in $TASK_FILE\''"
 +             ;;
 +         *)
 +             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
-+@@ -142,7 +147,7 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
-+     echo ""
-+     echo "After the agent responds, it will update your docs automatically."
-+     echo ""
-+-    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to 'auto'."
-++    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to \'auto\'."
-+     echo "Read $KEEPER_README_FILE for usage instructions"
-+     exit 0
++diff --git a/install.sh b/install.sh
++index a3030e8..8038c15 100755
++--- a/install.sh
+++++ b/install.sh
++@@ -1,7 +1,7 @@
++ #!/bin/bash
++ # Keeper Installer
++ # Usage: curl -fsSL https://keeper.dev/install.sh | bash
++-# CHASNGE
+++
++ set -e
++ 
++ echo "📚 Installing Keeper..."
++@@ -32,12 +32,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
++ CONFIG_FILE="$KEEPER_DIR/config.json"
++ TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
++ 
+++echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+++echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+++
++ if [ -f "$CONFIG_FILE" ]; then
++     TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
++     AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
++     AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
++     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
++-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
+++    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
++     
++     FILES_TO_UPDATE=()
++     while IFS= read -r line; do
++@@ -99,12 +102,12 @@ else
++     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 + fi
-+@@ -163,7 +168,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
-+                 AGENT_COMMAND="claude {{TASK_FILE}}"
-+                 ;;
-+             *)
-+-                echo "Keeper: Unknown agent '$AGENT_NAME'. Please configure 'agent_command' in your config.json."
-++                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
-+                 exit 1
-+                 ;;
-+         esac
-+@@ -172,7 +177,7 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
-+     FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
 + 
++-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
++-cat "$TEMPLATE_FILE" # ADDED DEBUG
++-echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
++-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
+++echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+++cat "$TEMPLATE_FILE" # Existing DEBUG
+++echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+++echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
++ PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
++-TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
+++TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
++ TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
++ 
++ echo "$TASK_CONTENT" > "$TASK_FILE"
++@@ -132,13 +135,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
 +     echo ""
-+-    echo " Keeper is calling the AI agent '$AGENT_NAME'. Please wait, this may take a few moments..."
-++    echo " Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait, this may take a few moments..."
-+     echo ""
-+     eval "$FINAL_COMMAND"
-+     echo ""
- ```
-diff --git a/.keeper/hook.sh b/.keeper/hook.sh
-index b735de9..2218ef1 100755
---- a/.keeper/hook.sh
-+++ b/.keeper/hook.sh
-@@ -7,12 +7,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
- CONFIG_FILE="$KEEPER_DIR/config.json"
- TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
++     case "$AGENT_NAME" in
++         "cline")
++-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
+++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
++             ;;
++         "aider")
++-            echo "  aider \'Read and complete the task in $TASK_FILE\'"
+++            echo "  aider \'Read and complete the task in $TASK_FILE\''"
++             ;;
++         "claude")
++-            echo "  claude \'Read and complete the task in $TASK_FILE\'"
+++            echo "  claude \'Read and complete the task in $TASK_FILE\''"
++             ;;
++         *)
++             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
++if [ -z "" ]; then
+     exit 0
+ fi
  
-+echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
-+echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
-+
- if [ -f "$CONFIG_FILE" ]; then
-     TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
-     AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
-     AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
-     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
--    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
-+    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
-     
-     FILES_TO_UPDATE=()
-     while IFS= read -r line; do
-@@ -74,12 +77,12 @@ else
+-if [ "$AUTO_COMMIT" = "true" ]; then
++if [ "" = "true" ]; then
+     COMMIT_INSTRUCTION="After completing this task, run: git add . && git commit -m \"docs: update documentation\""
+ else
      COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
  fi
  
--echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
--cat "$TEMPLATE_FILE" # ADDED DEBUG
--echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
--echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
-+echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
-+cat "$TEMPLATE_FILE" # Existing DEBUG
-+echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
-+echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
- PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
--TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
-+TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
- TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
- 
- echo "$TASK_CONTENT" > "$TASK_FILE"
-@@ -107,13 +110,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+-cat "$TEMPLATE_FILE" # Existing DEBUG
+-echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
+-PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
+-TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
+-TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
+-
+-echo "$TASK_CONTENT" > "$TASK_FILE"
+-
+-echo "" >> "$TASK_FILE"
+-echo "## Changed Files" >> "$TASK_FILE"
+-echo "\`\`\`" >> "$TASK_FILE"
+-echo "${FILES_TO_PROCESS[*]}" >> "$TASK_FILE"
+-echo "\`\`\`" >> "$TASK_FILE"
+-echo "" >> "$TASK_FILE"
+-echo "## Code Changes:" >> "$TASK_FILE"
+-echo "\`\`\`diff" >> "$TASK_FILE"
+-echo "$DIFF" >> "$TASK_FILE"
+-echo "\`\`\`" >> "$TASK_FILE"
+-
+-chmod +x $TASK_FILE
+-
+-if [ "$TRIGGER_MODE" = "interactive" ]; then
++if [ "" = "true" ]; then # ADDED
++    echo "DEBUG: PROMPT_TEMPLATE content starts here:"
++    cat ""
++    echo "DEBUG: PROMPT_TEMPLATE content ends here."
++    echo "DEBUG: COMMIT_INSTRUCTION is "
++fi # ADDED
++PROMPT_TEMPLATE=
++TASK_CONTENT= # CHANGED DELIMITER
++TASK_CONTENT=
++
++echo "" > ""
++
++echo "" >> ""
++echo "## Changed Files" >> ""
++echo "```" >> ""
++echo "" >> ""
++echo "```" >> ""
++echo "" >> ""
++echo "## Code Changes:" >> ""
++echo "```diff" >> ""
++echo "" >> ""
++echo "```" >> ""
++
++chmod +x 
++
++if [ "" = "interactive" ]; then
      echo ""
-     case "$AGENT_NAME" in
+     echo " Keeper has prepared a documentation update task"
+-    echo "📂: $TASK_FILE"
++    echo "📂: "
+     sleep 1
+     echo ""
+     echo "Call your agent as follows:"
+     echo ""
+-    case "$AGENT_NAME" in
++    case "" in
          "cline")
--            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
-+            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
+-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
++            echo "  cline -m act \'Read and complete the task in \'"
              ;;
          "aider")
--            echo "  aider \'Read and complete the task in $TASK_FILE\'"
-+            echo "  aider \'Read and complete the task in $TASK_FILE\''"
+-            echo "  aider \'Read and complete the task in $TASK_FILE\''"
++            echo "  aider \'Read and complete the task in \'"
              ;;
          "claude")
--            echo "  claude \'Read and complete the task in $TASK_FILE\'"
-+            echo "  claude \'Read and complete the task in $TASK_FILE\''"
+-            echo "  claude \'Read and complete the task in $TASK_FILE\''"
++            echo "  claude \'Read and complete the task in \'"
              ;;
          *)
-             echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
+-            echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
++            echo "  Please ask your coding agent to read and complete the task in "
+             ;;
+     esac
+     echo ""
+     echo "After the agent responds, it will update your docs automatically."
+     echo ""
+-    echo "Want to run Keeper in autonomous mode? Change $CONFIG_FILE.trigger_mode to \'auto\'."
+-    echo "Read $KEEPER_README_FILE for usage instructions"
++    echo "Want to run Keeper in autonomous mode? Change .keeper/config.json.trigger_mode to \'auto\'."
++    echo "Read .keeper/README.md for usage instructions"
+     exit 0
+ fi
+ 
+-if [ "$TRIGGER_MODE" = "auto" ]; then
++if [ "" = "auto" ]; then
+     AGENT_COMMAND=""
+-    if [ -n "$AGENT_COMMAND_OVERRIDE" ]; then
+-        AGENT_COMMAND="$AGENT_COMMAND_OVERRIDE"
++    if [ -n "" ]; then
++        AGENT_COMMAND=""
+     else
+-        case "$AGENT_NAME" in
++        case "" in
+             "cline")
+                 AGENT_COMMAND="cat {{TASK_FILE}} | cline --yolo"
+                 ;;
+@@ -146,25 +383,42 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+                 AGENT_COMMAND="claude {{TASK_FILE}}"
+                 ;;
+             *)
+-                echo "Keeper: Unknown agent \'$AGENT_NAME\'. Please configure \'agent_command\' in your config.json."
++                echo "Keeper: Unknown agent \'\'. Please configure \'agent_command\' in your config.json."
+                 exit 1
+                 ;;
+         esac
+     fi
+ 
+-    FINAL_COMMAND=$(echo "$AGENT_COMMAND" | sed "s|{{TASK_FILE}}|$TASK_FILE|g")
++    FINAL_COMMAND=
+ 
+     echo ""
+-    echo " Keeper is calling the AI agent \'$AGENT_NAME\'. Please wait, this may take a few moments..."
++    echo " Keeper is calling the AI agent \'\'. Please wait, this may take a few moments..."
+     echo ""
+-    eval "$FINAL_COMMAND"
++    eval ""
+     echo ""
+ 
+-    if [ "$AUTO_COMMIT" = "true" ]; then
+-        CHANGED_FILES_BY_AGENT=$(git diff HEAD~1 HEAD --name-only | wc -l)
+-        if [ "$CHANGED_FILES_BY_AGENT" -gt 0 ]; then
+-            echo " Keeper updated $CHANGED_FILES_BY_AGENT documentation file(s)"
++    if [ "" = "true" ]; then
++        # Get files changed by the agent
++        AGENT_CHANGED_FILES=(.keeper/agent-task.md
++.keeper/hook.sh
++install.sh)
++        CHANGED_FILES_BY_AGENT=0
++
++        if [ "" -gt 0 ]; then
++            echo " Keeper updated the following documentation file(s):"
++            for file in ""; do
++                echo "  - "
++            done
++            echo ""
++
++            echo "## Agent-Generated Documentation Changes:"
++            for file in ""; do
++                echo "### Diff for "
++                echo "```diff"
++                git diff HEAD~1 HEAD -- "" # Show diff for individual file
++                echo "```"
++                echo ""
++            done
+         fi
+     fi
+     exit 0
+-fi
 diff --git a/install.sh b/install.sh
-index a3030e8..8038c15 100755
+index 8038c15..5e65073 100755
 --- a/install.sh
 +++ b/install.sh
-@@ -1,7 +1,7 @@
+@@ -22,7 +22,7 @@ KEEPER_README_FILE="$KEEPER_DIR/README.md"
+ # Download core files
+ echo "⬇️  Downloading files..."
+ 
+-cat > .keeper/hook.sh << 'HOOK_EOF'
++cat > .keeper/hook.sh << EOF
  #!/bin/bash
- # Keeper Installer
- # Usage: curl -fsSL https://keeper.dev/install.sh | bash
--# CHASNGE
-+
- set -e
+ # Keeper Git Hook
  
- echo "📚 Installing Keeper..."
-@@ -32,12 +32,15 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
+@@ -32,15 +32,18 @@ TASK_FILE="$KEEPER_DIR/agent-task.md"
  CONFIG_FILE="$KEEPER_DIR/config.json"
  TEMPLATE_FILE="$KEEPER_DIR/prompt-template.md"
  
-+echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
-+echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
-+
+-echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE" # ADDED DEBUG
+-echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")" # ADDED DEBUG
+-
  if [ -f "$CONFIG_FILE" ]; then
      TRIGGER_MODE=$(jq -r ".trigger_mode // \"auto\"" "$CONFIG_FILE")
      AUTO_COMMIT=$(jq -r ".auto_commit // true" "$CONFIG_FILE")
      AGENT_NAME=$(jq -r ".agent // \"cline\"" "$CONFIG_FILE")
      AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
--    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # ADDED DEBUG
-+    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
+-    echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT" # Existing DEBUG
++    DEBUG_MODE=$(jq -r ".debug // false" "$CONFIG_FILE")
++
++    if [ "$DEBUG_MODE" = "true" ]; then # ADDED
++        echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE"
++        echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")"
++        echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT"
++    fi # ADDED
      
      FILES_TO_UPDATE=()
      while IFS= read -r line; do
-@@ -99,12 +102,12 @@ else
+@@ -56,6 +59,7 @@ else
+     AUTO_COMMIT="true"
+     AGENT_NAME="cline"
+     AGENT_COMMAND_OVERRIDE=""
++    DEBUG_MODE="false"
+     FILES_TO_UPDATE=("README.md" "docs/")
+     EXCLUDE_PATTERNS=(".keeper/*" "keeper/*")
+ fi
+@@ -102,10 +106,12 @@ else
      COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
  fi
  
--echo "DEBUG: PROMPT_TEMPLATE content starts here:" # ADDED DEBUG
--cat "$TEMPLATE_FILE" # ADDED DEBUG
--echo "DEBUG: PROMPT_TEMPLATE content ends here." # ADDED DEBUG
--echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # ADDED DEBUG
-+echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
-+cat "$TEMPLATE_FILE" # Existing DEBUG
-+echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
-+echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
+-echo "DEBUG: PROMPT_TEMPLATE content starts here:" # Existing DEBUG
+-cat "$TEMPLATE_FILE" # Existing DEBUG
+-echo "DEBUG: PROMPT_TEMPLATE content ends here." # Existing DEBUG
+-echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION" # Existing DEBUG
++if [ "$DEBUG_MODE" = "true" ]; then # ADDED
++    echo "DEBUG: PROMPT_TEMPLATE content starts here:"
++    cat "$TEMPLATE_FILE"
++    echo "DEBUG: PROMPT_TEMPLATE content ends here."
++    echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION"
++fi # ADDED
  PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
--TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s/{{COMMIT_INSTRUCTION}}/$COMMIT_INSTRUCTION/g")
-+TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
+ TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
  TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
- 
- echo "$TASK_CONTENT" > "$TASK_FILE"
-@@ -132,13 +135,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
+@@ -135,13 +141,13 @@ if [ "$TRIGGER_MODE" = "interactive" ]; then
      echo ""
      case "$AGENT_NAME" in
          "cline")
--            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
-+            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
+-            echo "  cline -m act \'Read and complete the task in $TASK_FILE\''"
++            echo "  cline -m act \'Read and complete the task in $TASK_FILE\'"
              ;;
          "aider")
--            echo "  aider \'Read and complete the task in $TASK_FILE\'"
-+            echo "  aider \'Read and complete the task in $TASK_FILE\''"
+-            echo "  aider \'Read and complete the task in $TASK_FILE\''"
++            echo "  aider \'Read and complete the task in $TASK_FILE\'"
              ;;
          "claude")
--            echo "  claude \'Read and complete the task in $TASK_FILE\'"
-+            echo "  claude \'Read and complete the task in $TASK_FILE\''"
+-            echo "  claude \'Read and complete the task in $TASK_FILE\''"
++            echo "  claude \'Read and complete the task in $TASK_FILE\'"
              ;;
          *)
              echo "  Please ask your coding agent to read and complete the task in $TASK_FILE"
+@@ -186,14 +192,29 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
+     echo ""
+ 
+     if [ "$AUTO_COMMIT" = "true" ]; then
+-        CHANGED_FILES_BY_AGENT=$(git diff HEAD~1 HEAD --name-only | wc -l)
++        # Get files changed by the agent
++        AGENT_CHANGED_FILES=($(git diff HEAD~1 HEAD --name-only))
++        CHANGED_FILES_BY_AGENT=${#AGENT_CHANGED_FILES[@]}
++
+         if [ "$CHANGED_FILES_BY_AGENT" -gt 0 ]; then
+-            echo " Keeper updated $CHANGED_FILES_BY_AGENT documentation file(s)"
++            echo " Keeper updated the following documentation file(s):"
++            for file in "${AGENT_CHANGED_FILES[@]}"; do
++                echo "  - $file"
++            done
++            echo ""
++
++            echo "## Agent-Generated Documentation Changes:"
++            for file in "${AGENT_CHANGED_FILES[@]}"; do
++                echo "### Diff for $file"
++                echo "\`\`\`diff"
++                git diff HEAD~1 HEAD -- "$file" # Show diff for individual file
++                echo "\`\`\`"
++                echo ""
++            done
+         fi
+     fi
+     exit 0
+-fi
+-HOOK_EOF
++EOF
+ 
+ cat > "$CONFIG_FILE" << 'CONFIG_EOF'
+ {
+@@ -253,6 +274,7 @@ Agent-powered documentation that stays in sync with your code.
+ Edit `$CONFIG_FILE` to customize:
+ - `trigger_mode`: "auto" or "interactive".
+ - `auto_commit`: `true` or `false`.
++- `debug`: `true` or `false`.
+ - `agent`: The name of your preferred coding agent. Supported agents: `cline`, `aider`, `claude`.
+ - `agent_command` (optional): Provide a custom command to run your agent. Use `{{TASK_FILE}}` as a placeholder for the task file path.
+ - `files_to_update`: A list of documentation files and directories to keep updated.
 if [ -z "" ]; then
     exit 0
 fi
@@ -312,12 +842,12 @@ else
     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 fi
 
-if [ "" = "true" ]; then # ADDED
+if [ "" = "true" ]; then
     echo "DEBUG: PROMPT_TEMPLATE content starts here:"
     cat ""
     echo "DEBUG: PROMPT_TEMPLATE content ends here."
     echo "DEBUG: COMMIT_INSTRUCTION is "
-fi # ADDED
+fi 
 PROMPT_TEMPLATE=
 TASK_CONTENT= # CHANGED DELIMITER
 TASK_CONTENT=
@@ -405,13 +935,13 @@ install.sh)
         CHANGED_FILES_BY_AGENT=0
 
         if [ "" -gt 0 ]; then
-            echo " Keeper updated the following documentation file(s):"
+            echo " Keeper updated the following file(s):"
             for file in ""; do
                 echo "  - "
             done
             echo ""
 
-            echo "## Agent-Generated Documentation Changes:"
+            echo " Documentation Changes:"
             for file in ""; do
                 echo "### Diff for "
                 echo "```diff"
diff --git a/install.sh b/install.sh
index 5e65073..74d72a7 100755
--- a/install.sh
+++ b/install.sh
@@ -39,11 +39,11 @@ if [ -f "$CONFIG_FILE" ]; then
     AGENT_COMMAND_OVERRIDE=$(jq -r ".agent_command // \"\"" "$CONFIG_FILE")
     DEBUG_MODE=$(jq -r ".debug // false" "$CONFIG_FILE")
 
-    if [ "$DEBUG_MODE" = "true" ]; then # ADDED
+    if [ "$DEBUG_MODE" = "true" ]; then 
         echo "DEBUG: CONFIG_FILE path is $CONFIG_FILE"
         echo "DEBUG: Does config.json exist? $([ -f "$CONFIG_FILE" ] && echo "yes" || echo "no")"
         echo "DEBUG: AUTO_COMMIT is $AUTO_COMMIT"
-    fi # ADDED
+    fi
     
     FILES_TO_UPDATE=()
     while IFS= read -r line; do
@@ -72,7 +72,7 @@ FILES_TO_PROCESS=()
 for file in "${ALL_CHANGED_FILES[@]}"; do
     is_excluded=false
     for pattern in "${EXCLUDE_PATTERNS[@]}"; do
-        if [[ "$file" == $pattern ]]; then
+        if [[ "$file" == "$pattern" ]]; then
             is_excluded=true
             break
         fi
@@ -106,12 +106,12 @@ else
     COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
 fi
 
-if [ "$DEBUG_MODE" = "true" ]; then # ADDED
+if [ "$DEBUG_MODE" = "true" ]; then
     echo "DEBUG: PROMPT_TEMPLATE content starts here:"
     cat "$TEMPLATE_FILE"
     echo "DEBUG: PROMPT_TEMPLATE content ends here."
     echo "DEBUG: COMMIT_INSTRUCTION is $COMMIT_INSTRUCTION"
-fi # ADDED
+fi 
 PROMPT_TEMPLATE=$(cat "$TEMPLATE_FILE")
 TASK_CONTENT=$(echo "$PROMPT_TEMPLATE" | sed "s#{{COMMIT_INSTRUCTION}}#$COMMIT_INSTRUCTION#g") # CHANGED DELIMITER
 TASK_CONTENT=$(echo "$TASK_CONTENT" | sed "s|{{FILES_TO_UPDATE}}|${FILES_TO_UPDATE[*]}|g")
@@ -197,13 +197,13 @@ if [ "$TRIGGER_MODE" = "auto" ]; then
         CHANGED_FILES_BY_AGENT=${#AGENT_CHANGED_FILES[@]}
 
         if [ "$CHANGED_FILES_BY_AGENT" -gt 0 ]; then
-            echo " Keeper updated the following documentation file(s):"
+            echo " Keeper updated the following file(s):"
             for file in "${AGENT_CHANGED_FILES[@]}"; do
                 echo "  - $file"
             done
             echo ""
 
-            echo "## Agent-Generated Documentation Changes:"
+            echo " Documentation Changes:"
             for file in "${AGENT_CHANGED_FILES[@]}"; do
                 echo "### Diff for $file"
                 echo "\`\`\`diff"
if [ -z "" ]; then
    exit 0
fi

if [ "" = "true" ]; then
    COMMIT_INSTRUCTION="After completing this task, run: git add . && git commit -m \"docs: update documentation\""
else
    COMMIT_INSTRUCTION="The documentation files have been updated. Please review and commit them."
fi

if [ "" = "true" ]; then
    echo "DEBUG: PROMPT_TEMPLATE content starts here:"
    cat ""
    echo "DEBUG: PROMPT_TEMPLATE content ends here."
    echo "DEBUG: COMMIT_INSTRUCTION is "
fi 
PROMPT_TEMPLATE=
TASK_CONTENT= # CHANGED DELIMITER
TASK_CONTENT=

echo "" > ""

echo "" >> ""
echo "## Changed Files" >> ""
echo "```" >> ""
echo "" >> ""
echo "```" >> ""
echo "" >> ""
echo "## Code Changes:" >> ""
echo "```diff" >> ""
echo "" >> ""
echo "```" >> ""

chmod +x 

if [ "" = "interactive" ]; then
    echo ""
    echo " Keeper has prepared a documentation update task"
    echo "📂: "
    sleep 1
    echo ""
    echo "Call your agent as follows:"
    echo ""
    case "" in
        "cline")
            echo "  cline -m act \'Read and complete the task in \'"
            ;;
        "aider")
            echo "  aider \'Read and complete the task in \'"
            ;;
        "claude")
            echo "  claude \'Read and complete the task in \'"
            ;;
        *)
            echo "  Please ask your coding agent to read and complete the task in "
            ;;
    esac
    echo ""
    echo "After the agent responds, it will update your docs automatically."
    echo ""
    echo "Want to run Keeper in autonomous mode? Change .keeper/config.json.trigger_mode to \'auto\'."
    echo "Read .keeper/README.md for usage instructions"
    exit 0
fi

if [ "" = "auto" ]; then
    AGENT_COMMAND=""
    if [ -n "" ]; then
        AGENT_COMMAND=""
    else
        case "" in
            "cline")
                AGENT_COMMAND="cat {{TASK_FILE}} | cline --yolo"
                ;;
            "aider")
                AGENT_COMMAND="aider {{TASK_FILE}}"
                ;;
            "claude")
                AGENT_COMMAND="claude {{TASK_FILE}}"
                ;;
            *)
                echo "Keeper: Unknown agent \'\'. Please configure \'agent_command\' in your config.json."
                exit 1
                ;;
        esac
    fi

    FINAL_COMMAND=

    echo ""
    echo " Keeper is calling the AI agent \'\'. Please wait, this may take a few moments..."
    echo ""
    eval ""
    echo ""

    if [ "" = "true" ]; then
        # Get files changed by the agent
        AGENT_CHANGED_FILES=(.keeper/README.md
.keeper/hook.sh
install.sh)
        CHANGED_FILES_BY_AGENT=0

        if [ "" -gt 0 ]; then
            echo " Keeper updated the following file(s):"
            for file in ""; do
                echo "  - "
            done
            echo ""

            echo " Documentation Changes:"
            for file in ""; do
                echo "### Diff for "
                echo "```diff"
                git diff HEAD~1 HEAD -- "" # Show diff for individual file
                echo "```"
                echo ""
            done
        fi
    fi
    exit 0
