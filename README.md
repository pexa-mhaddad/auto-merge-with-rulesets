# Auto-Merge with Rulesets for Dependabot PRs

This repository demonstrates how to implement auto-merge functionality for Dependabot PRs using GitHub rulesets in a multi-ecosystem project structure. It serves as a proof of concept for the evergreen initiative to streamline dependency updates.

## Repository Structure

- `/terraform` - Contains Terraform code with AWS provider dependency
- `/npm` - Contains a Node.js project with npm dependencies
- `/kotlin` - Contains a Kotlin project with Maven dependencies
- `/.github` - Contains GitHub workflows, Dependabot configuration, and rulesets

## How It Works

1. **Dependabot Configuration**: Monitors Terraform, npm, and Maven dependencies
2. **Conditional Workflow**: Triggers specific validation jobs based on PR labels:
   - `auto_merge_terraform` job for Terraform changes (with 'terraform' label)
   - `auto_merge_npm` job for npm changes (with 'javascript' label)
   - `auto_merge_kotlin` job for Kotlin changes (with 'java' label)
3. **Single Status Check**: A `workflow_status` job serves as the single required status check
4. **Auto-Merge Process**: Dependabot PRs that pass validation are automatically merged

## Implementation Details

### 1. Single Workflow Status Check
- A single dependabot workflow triggers existing reusable workflows based on PR labels
- The `workflow_status` job serves as the single required status check named `dependabot-auto-merge`
- This approach follows the solution described in [GitHub Community Discussion](https://github.com/orgs/community/discussions/12395#discussioncomment-12970019)

### 2. Ruleset Configuration
- Repository uses a ruleset located in `.github/rulesets/dependabot-auto-merge.json`
- Enforces the `dependabot-auto-merge` status check for the main branch
- Includes protection against branch deletion and non-fast-forward updates
- Allows repository maintainers to bypass the required check when necessary

### 3. Workflow Modifications
- Ecosystem-specific workflows (npm.yml, kotlin.yml, terraform.yml) contain conditional logic
- Each workflow includes `if: github.actor != 'dependabot[bot]'` to prevent duplicate runs
- Workflows are reused through the workflow_call trigger in the conditional workflow

### 4. Auto-merge Process
1. Dependabot creates a PR with appropriate labels (javascript, java, or terraform)
2. The conditional workflow in `.github/workflows/conditional.yml` triggers based on these labels
3. Specific validation jobs run for the affected ecosystem using reusable workflows
4. The `workflow_status` job runs as a status check named `dependabot-auto-merge`
5. If validation passes, the `enable_automerge` job automatically merges the PR

## Dependabot Configuration

Dependabot is configured in `.github/dependabot.yml` to:
- Monitor Terraform dependencies in `/terraform` directory
- Monitor npm dependencies in `/npm` directory
- Monitor Maven dependencies in `/kotlin` directory
- Check for updates weekly with a limit of 5 open PRs per ecosystem

## Implementation for Other Repositories

To implement this approach in other repositories:

1. **Analyze Repository Structure**:
   - Identify package ecosystems used in the repository
   - Determine which existing workflows can be reused

2. **Workflow Adaptation**:
   - Create a conditional workflow similar to this POC
   - Modify existing workflows to include the necessary conditional logic
   - Implement the workflow_status job as the required status check

3. **Ruleset/Branch Protection Setup**:
   - Configure appropriate branch protection or ruleset
   - Set up the single required status check
   - Configure team bypass permissions

4. **Dependabot Configuration**:
   - Ensure Dependabot is configured to create appropriate labels
   - Configure update types (patch/minor/major) eligible for auto-merge

## References

- [GitHub Community Discussion on Auto-merge](https://github.com/orgs/community/discussions/12395#discussioncomment-12970019)
- [GitHub Dependabot Auto-merge Documentation](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/automating-dependabot-with-github-actions#enabling-automerge-on-a-pull-request)