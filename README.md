# What 2 Play

A modern, serverless web app that finally ends the eternal group debate: **“What should we play tonight?”**  
Friends register the games/activities they own, weight how much they want to play each one, join a temporary group — the app intelligently recommends the fairest, most exciting option for everyone.

Originally built ~10 years ago as a C# Discord bot. Rebuilt in 2025–2026 as a production-grade portfolio showcase.

## Why This Project Exists (Career & Portfolio Value)

- 100% AWS serverless stack — my deepest expertise  
- Full end-to-end ownership: auth → data modeling → IaC → CI/CD → AI augmentation  
- Real user accounts & persistent data (not a toy demo)  
- Live, shareable URL on my personal domain  
- Deliberate growth edges (TypeScript, GitHub Actions, agentic AI) without over-engineering  
- Perfect senior/lead interview artifact: “Tell me about a system you built from scratch”

## Tech Stack

| Layer               | Technology                              | Reason / Showcase Area                        |
|---------------------|-----------------------------------------|-----------------------------------------------|
| Frontend            | React + Vite + TypeScript (gradual)     | Core strength + modern growth signal          |
| Hosting             | S3 + CloudFront                         | Same pattern as seanezell.com                 |
| Auth                | Amazon Cognito User Pools + Hosted UI   | Production-grade identity                     |
| Backend             | Node.js Lambda functions (API Gateway)  | Serverless microservices                      |
| Database            | Amazon DynamoDB                         | NoSQL modeling expertise                      |
| Infrastructure      | Terraform (single repo)                 | Full IaC — my strongest differentiator        |
| CI/CD               | GitHub Actions                          | Leveling up from Azure DevOps                 |
| AI Enrichment       | IGDB API + AWS Bedrock (Claude 3.5)     | Smart game metadata & recommendation engine   |
| Real-time (future)  | AppSync GraphQL or polling              | Optional polish                               |

## Repository Layout (4 repos total)
what2play-infrastructure/   → Terraform (all AWS resources)
what2play-client/           → React frontend (S3/CloudFront)
what2play-services/         → Node.js Lambda microservices (monorepo)
what2play-ai-prompts/       → Prompt library & examples (optional)


## Architecture Highlights

- Cognito → JWT → API Gateway authorizer → Lambdas
- All business data in DynamoDB (optimized GSIs for fast group queries)
- Game catalog enriched automatically via IGDB + Bedrock
- Final group recommendation powered by Claude (replaces 10-year-old manual weighting logic)
- Fully defined and deployed with Terraform
- GitHub Actions for plan/apply + client deployment

## Development Phases (No Deadline – Pure Side-Project Joy)

### Phase 0 – Setup
- [:white_check_mark:] Create 4 GitHub repositories
- [:white_check_mark:] Add AWS credentials as GitHub secrets
- [ ] Draft architecture diagram (draw.io)

### Phase 1 – Infrastructure First
- [:white_check_mark:] Route53 + CloudFront + S3 (what2play.seanezell.com)
- [ ] Cognito User Pool + App Client + Hosted UI
- [ ] DynamoDB tables (Games, UserGames, Groups + GSIs)
- [ ] API Gateway + Lambda proxy skeleton
- [ ] GitHub Actions Terraform workflow

### Phase 2 – Client MVP
- [ ] Vite + React + TypeScript + Tailwind/MUI
- [ ] Cognito auth flow (Hosted UI)
- [ ] “My Games” page with weight slider
- [ ] Deploy to S3/CloudFront

### Phase 3 – Backend Services
- [ ] Games Service (IGDB search → Bedrock enrichment → store)
- [ ] Users Service (manage weights)
- [ ] Groups Service (create group + AI recommendation endpoint)

### Phase 4 – AI Magic
- [ ] IGDB API integration
- [ ] Bedrock → Claude for game blurbs and final group pick + explanation
- [ ] Prompt library (gold for technical interviews)

### Phase 5 – Polish & Portfolio
- [ ] Real-time updates (optional)
- [ ] PWA support
- [ ] Case study + screenshots on seanezell.com
- [ ] Project card with tech badges on main portfolio
- [ ] Loom walkthrough video

### Future Ideas (only if fun)
- Discord/Slack bot integration
- Veto + re-roll
- Historical stats dashboard

## Local Development

(See individual repo READMEs — will be added as they’re built)

## License

Private for portfolio use. Happy to open-source or share privately during interview processes.

Built with React, Node.js, AWS, Terraform, and a lot of fun — Sean Ezell © 2025–2026
