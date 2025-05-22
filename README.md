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
3. GitHub rulesets enforce specific status checks:
   - Terraform updates only require Terraform-specific checks
   - npm updates only require npm-specific checks
   - Kotlin updates only require Kotlin-specific checks
4. Dependabot auto-merge is configured to merge PRs that pass the required checks

## Ruleset Configuration

The repository uses three rulesets located in `.github/rulesets/`:
- `terraform.json` - Enforces `auto_merge_terraform` status check
- `npm.json` - Enforces `auto_merge_npm` status check
- `kotlin.json` - Enforces `auto_merge_kotlin` status check

Each ruleset is configured to apply to the default branch and includes protection against branch deletion and non-fast-forward updates.

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
3. Specific validation jobs run for the affected ecosystem
4. If validation passes, the PR is automatically merged

## Testing Instructions

1. Push this code to your GitHub repository
2. In the GitHub repository settings, navigate to "Code security and analysis"
3. Enable Dependabot security updates and version updates
4. Navigate to "Settings" > "Code and automation" > "Rulesets"
5. Create three new rulesets using the JSON files in `.github/rulesets/`:
   - Create a ruleset for Terraform using `terraform.json`
   - Create a ruleset for npm using `npm.json`
   - Create a ruleset for Kotlin using `kotlin.json`
6. Configure the rulesets to apply to Dependabot PRs that modify files in their respective directories
7. Wait for Dependabot to create PRs or trigger them manually
8. Observe that:
   - PRs updating Terraform dependencies only need to pass Terraform checks
   - PRs updating npm dependencies only need to pass npm checks
   - PRs updating Kotlin dependencies only need to pass Kotlin checks
   - PRs that pass their respective checks are auto-merged


https://github.com/orgs/community/discussions/12395