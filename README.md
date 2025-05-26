# GitHub Rulesets with Dependabot Auto-Merge Test

This repository demonstrates how to use GitHub rulesets with Dependabot auto-merge in a monorepo structure.

## Repository Structure

- `/terraform` - Contains Terraform code with AWS provider dependency
- `/npm` - Contains a Node.js project with npm dependencies
- `/kotlin` - Contains a Kotlin project with Maven dependencies
- `/.github` - Contains GitHub workflows, Dependabot configuration, and rulesets

## How It Works

1. Dependabot is configured to monitor Terraform, npm, and Maven dependencies
2. A conditional workflow triggers specific validation jobs based on PR labels:
   - `auto_merge_terraform` job for Terraform changes (with 'terraform' label)
   - `auto_merge_npm` job for npm changes (with 'javascript' label)
   - `auto_merge_kotlin` job for Kotlin changes (with 'java' label)
3. GitHub rulesets enforce specific status checks
4. Dependabot auto-merge is configured to merge PRs that pass the required checks

## Ruleset Configuration

The repository uses two rulesets located in `.github/rulesets/`:
- `dependabot-auto-merge.json` - Enforces `dependabot-auto-merge` status check for Dependabot PRs (currently active)
- `developer-checks.json` - Enforces build, test, and lint status checks for developer PRs (currently disabled)

Each ruleset is configured to apply to the default branch and includes protection against branch deletion and non-fast-forward updates. The dependabot-auto-merge ruleset is currently active, while the developer-checks ruleset is currently disabled.

## Dependabot Configuration

Dependabot is configured in `.github/dependabot.yml` to:
- Monitor Terraform dependencies in `/terraform` directory
- Monitor npm dependencies in `/npm` directory
- Monitor Maven dependencies in `/kotlin` directory
- Check for updates weekly with a limit of 5 open PRs per ecosystem

## Auto-Merge Workflow

The auto-merge process works as follows:
1. Dependabot creates a PR with appropriate labels (javascript, java, or terraform)
2. The conditional workflow in `.github/workflows/conditional.yml` triggers based on these labels
3. Specific validation jobs run for the affected ecosystem using reusable workflows:
   - `.github/workflows/npm.yml` for npm dependencies
   - `.github/workflows/kotlin.yml` for Kotlin dependencies
   - `.github/workflows/terraform.yml` for Terraform dependencies
4. The `workflow_status` job runs as a status check named `dependabot-auto-merge`
5. If validation passes, the `enable_automerge` job automatically merges the PR

## Developer Workflow

For non-Dependabot PRs, a separate workflow in `.github/workflows/developer-checks.yml`:
1. Runs specific checks based on which directories have changes
2. Executes build, test, and lint jobs that are required by the `developer-checks` ruleset
3. Note that while the ruleset is currently disabled, the workflow will still run the checks

## Implementation Notes

- Each ecosystem-specific workflow (npm.yml, kotlin.yml, terraform.yml) contains an `if` condition to exclude Dependabot PRs when run directly, but they are called by the conditional workflow for Dependabot PRs
- The workflows can be triggered by:
  - Pull requests that modify files in their respective directories
  - Manual workflow dispatch
  - Being called by other workflows (workflow_call)
- The npm workflow validates the package by installing dependencies and running the index.js file
- The Kotlin workflow validates the project by compiling it with Maven
- The Terraform workflow validates the configuration by running terraform init and terraform validate

## Testing Instructions

1. Push this code to your GitHub repository
2. In the GitHub repository settings, navigate to "Code security and analysis"
3. Enable Dependabot security updates and version updates
4. Navigate to "Settings" > "Code and automation" > "Rulesets"
5. Create two new rulesets using the JSON files in `.github/rulesets/`:
   - Create a ruleset for Dependabot PRs using `dependabot-auto-merge.json` (set to active)
   - Create a ruleset for developer PRs using `developer-checks.json` (can be enabled as needed)
6. Configure the rulesets to apply to their respective PR types
7. Wait for Dependabot to create PRs or trigger them manually
8. Observe that:
   - Dependabot PRs only need to pass their ecosystem-specific checks
   - Developer PRs will run all checks defined in the workflow
   - Dependabot PRs that pass their checks will be automatically merged

https://github.com/orgs/community/discussions/12395
https://docs.github.com/en/code-security/dependabot/working-with-dependabot/automating-dependabot-with-github-actions#enabling-automerge-on-a-pull-request