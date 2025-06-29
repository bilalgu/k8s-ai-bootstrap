# Step 3 - CI/CD with GitHub Actions

**Objective:**

Automate the build and push of the AI API Docker image to Docker Hub on every change in the `app/` directory.

**Stack:**

- [GitHub Actions](https://docs.github.com/en/actions)
- [Docker Hub](https://hub.docker.com/)

**File structure:**

```
.  
├── .github/
│   └── workflows/
│       └── deploy.yml
```

**Notes:**

- Secrets:
	- `DOCKERHUB_USERNAME` (set as GitHub variable)
	- `DOCKERHUB_TOKEN` (set as GitHub secret)

**Deployment:**

The workflow is defined to run on `push` to `main` when files under `app/` are modified.

A temporary branch may be used to test the workflow before merging to `main`.  
For this, adjust the workflow trigger and tag as needed:

- `branches: main` → `branches: ci-cd-test`

- `bilalguirre/ai-api:v1` → `bilalguirre/ai-api:test`

Test branch example:

```bash
git checkout -b ci-cd-test
echo "#Test $(date)" >> app/ci-cd-test.txt
git add app/ci-cd-test.txt
git commit -m "ci/cd trigger test"
git push --set-upstream origin ci-cd-test
```

When the workflow is validated, squash the test branch to keep `main` clean:

```bash
git checkout main
git merge --squash ci-cd-test
git commit -m "ci: add GitHub Actions workflow"
git push
git branch -d ci-cd-test
git push origin --delete ci-cd-test
```

**Validation:**

1. Verify that the workflow runs successfully in the repository’s Actions tab.

2. Confirm that the updated Docker image is available in Docker Hub: `https://hub.docker.com/repository/docker/bilalguirre/ai-api`

3. Clean up any test images or tags if required.