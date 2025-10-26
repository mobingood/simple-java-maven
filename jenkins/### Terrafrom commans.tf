### Terrafrom commans 

terraform init
terraform plan
terraform apply -auto-approve

Here’s a complete and **easy-to-remember list of Terraform commands**, grouped by purpose — from setup to debugging.

---

## 🧱 **1️⃣ Initialization & Setup**

| Command               | Description                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------ |
| `terraform init`      | Initializes a Terraform working directory (downloads providers, modules, backend configs). |
| `terraform validate`  | Checks if your configuration syntax is valid.                                              |
| `terraform fmt`       | Formats Terraform files (`.tf`) to canonical style.                                        |
| `terraform providers` | Shows providers used in the current configuration.                                         |

---

## 📋 **2️⃣ Planning & Execution**

| Command                                   | Description                                                                    |
| ----------------------------------------- | ------------------------------------------------------------------------------ |
| `terraform plan`                          | Shows what Terraform will do (create, change, destroy).                        |
| `terraform apply`                         | Applies the configuration to create/update infrastructure.                     |
| `terraform apply -auto-approve`           | Applies changes without asking for confirmation.                               |
| `terraform destroy`                       | Destroys all managed infrastructure.                                           |
| `terraform destroy -target=resource.name` | Destroys a specific resource only.                                             |
| `terraform refresh`                       | Updates the state file with real-world resource data (without changing infra). |

---

## 📦 **3️⃣ Resource Management**

| Command                            | Description                                                        |
| ---------------------------------- | ------------------------------------------------------------------ |
| `terraform state list`             | Lists resources tracked in Terraform state.                        |
| `terraform state show <resource>`  | Shows details of a resource in state.                              |
| `terraform state rm <resource>`    | Removes a resource from state (Terraform stops managing it).       |
| `terraform taint <resource>`       | Marks a resource for recreation on next apply.                     |
| `terraform untaint <resource>`     | Removes the taint mark.                                            |
| `terraform import <resource> <id>` | Brings an existing real-world resource under Terraform management. |

---

## 🧠 **4️⃣ Variables & Outputs**

| Command                   | Description                                                     |
| ------------------------- | --------------------------------------------------------------- |
| `terraform output`        | Shows output values after apply.                                |
| `terraform output <name>` | Shows specific output variable.                                 |
| `terraform console`       | Opens an interactive console to evaluate Terraform expressions. |

---

## 🗂️ **5️⃣ Workspaces (for multi-environment setup)**

| Command                             | Description                                    |
| ----------------------------------- | ---------------------------------------------- |
| `terraform workspace list`          | Lists all workspaces.                          |
| `terraform workspace show`          | Shows current workspace.                       |
| `terraform workspace new <name>`    | Creates a new workspace (e.g., `dev`, `prod`). |
| `terraform workspace select <name>` | Switches to a workspace.                       |
| `terraform workspace delete <name>` | Deletes a workspace.                           |

---

## 🧾 **6️⃣ File & State Management**

| Command                | Description                                          |
| ---------------------- | ---------------------------------------------------- |
| `terraform show`       | Displays current state or plan.                      |
| `terraform state pull` | Downloads the remote state file locally.             |
| `terraform state push` | Uploads a modified state file to remote backend.     |
| `terraform graph`      | Generates a visual dependency graph (in DOT format). |

---

## 🪛 **7️⃣ Debugging & Logging**

| Command                              | Description                                                                     |
| ------------------------------------ | ------------------------------------------------------------------------------- |
| `TF_LOG=TRACE terraform apply`       | Enables detailed debug logs. Levels: `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`. |
| `TF_LOG_PATH=log.txt terraform plan` | Saves logs to a file.                                                           |

---

## 🔐 **8️⃣ Cloud & Backend**

| Command            | Description                                                      |
| ------------------ | ---------------------------------------------------------------- |
| `terraform login`  | Authenticates with Terraform Cloud.                              |
| `terraform logout` | Removes saved credentials.                                       |
| `terraform remote` | (Deprecated) Used for remote state management in older versions. |

---

## ⚡ **9️⃣ Common Shortcuts**

| Action              | Command                                          |
| ------------------- | ------------------------------------------------ |
| Initialize project  | `terraform init`                                 |
| Format and validate | `terraform fmt -recursive && terraform validate` |
| Preview changes     | `terraform plan`                                 |
| Apply changes       | `terraform apply`                                |
| Destroy all infra   | `terraform destroy`                              |

---

Would you like me to give you a **Terraform command cheat sheet (PDF)** with examples and short notes (ready to print)?
