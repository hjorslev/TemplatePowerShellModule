# TemplatePowerShellModule

## Module Status

[![AppVeyor master](https://img.shields.io/appveyor/ci/SET_USERNAME/SET_REPONAME/master?label=MASTER&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/SET_USERNAME/SET_REPONAME)
[![AppVeyor tests (master)](https://img.shields.io/appveyor/tests/SET_USERNAME/SET_REPONAME/master?label=MASTER&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/SET_USERNAME/SET_REPONAME/build/tests)
[![AppVeyor dev](https://img.shields.io/appveyor/ci/SET_USERNAME/SET_REPONAME/DEV?label=DEV&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/SET_USERNAME/SET_REPONAME)
[![AppVeyor tests (dev)](https://img.shields.io/appveyor/tests/SET_USERNAME/SET_REPONAME/dev?label=DEV&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/SET_USERNAME/SET_REPONAME/build/tests)
[![PowerShell Version](https://img.shields.io/powershellgallery/v/SET_REPONAME.svg?style=for-the-badge&logo=PowerShell)](https://www.powershellgallery.com/packages/SET_REPONAME)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/SET_REPONAME?style=for-the-badge)](https://www.powershellgallery.com/packages/SET_REPONAME)

## TemplatePowerShellModule Title

{Super High level description}

## Synopsis

A PowerShell Module to

## Description

A PowerShell Module to

## Using TemplatePowerShellModule

This is a template PowerShell module that includes a pipeline that builds the
module (documentation etc.), commits documentation and external help to GitHub
and deploys the module to the [PowerShell Gallery](https://www.powershellgallery.com).

### Change variables

Change the name in *LICENSE.md* if you plan using it.

### Building with AppVeyor and deploy to PS Gallery

AppVeyor is free for open source projects.

1. Create an account etc. at AppVeyor
2. Link your GitHub account
3. [Create new project at AppVeyor](https://ci.appveyor.com/projects)
4. [Create API-key at PS Gallery](https://www.powershellgallery.com/account/apikeys)
5. [Encrypt API-key at AppVeyor](https://ci.appveyor.com/tools/encrypt)
and add it to appveyor.yml by replacing `{NUGETAPIKEY}`.
6. [Create Personal access tokens at GitHub](https://github.com/settings/tokens)
with scope to edit repos.
7. [Encrypt token at AppVeyor](https://ci.appveyor.com/tools/encrypt)
and add it to appveyor.yml by replacing `{GITHUB_PERSONAL_ACCESS_TOKEN}`.
8. AppVeyor will now monitor your master branch and deploy a new version to
the [PowerShell Gallery](https://www.powershellgallery.com)
when it detects a new commit.
