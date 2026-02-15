---
name: swagger-governance
description: Enforces OpenAPI best practices for NestJS projects including enum normalization, DTO modeling, SDK stability, and documentation hygiene.
license: MIT
compatibility: opencode
metadata:
  domain: backend
  framework: nestjs
  output: openapi
---

## What I do

I review and optimize Swagger / OpenAPI implementations in NestJS applications.

I ensure:

1. All enums are defined once and use `enumName` in decorators.
2. Query parameters are modeled through DTOs instead of inline enums.
3. Admin and client endpoints use consistent `@ApiTags`.
4. SwaggerModule setup includes stable JSON document URL.
5. Generated SDK does not contain duplicate enums or model collisions.
6. Proper versioning strategy exists (`/v1`, `/v2`).
7. Bearer auth and global headers are consistently defined.
8. OpenAPI schema names are deterministic and reusable.

If duplication is detected, I refactor toward:
• DTO abstraction
• Explicit enum naming
• useUnionTypes compatibility
• Clean generator configuration

---

## When to use me

Use this skill when:

• OpenAPI generator throws duplicate enum errors  
• SDK builds fail in Vite or CI  
• Swagger documentation becomes inconsistent  
• Admin/client controllers share overlapping models  
• Query enums generate long auto-names  
• You are scaling an API and need schema stability  
• Preparing API for external SDK consumers  

---

## Best Practices I Enforce

### DTO-first Query Modeling

Never use:

@ApiQuery({ enum: SortBy })

Always use:

class QueryDto {
  @ApiProperty({
    enum: SortBy,
    enumName: 'SortBy'
  })
  sortBy: SortBy;
}

---

### Explicit Enum Naming

All enums must define:

@ApiProperty({
  enum: RoleEnum,
  enumName: 'RoleEnum'
})

This prevents:
UserControllerFindAllRoleEnum duplication.

---

### Stable Swagger Setup

Ensure:

SwaggerModule.setup('docs', app, document, {
  jsonDocumentUrl: '/docs/json',
});

---

### SDK Generation Standard

Recommended generator flags:

useUnionTypes=true  
modelSuffix=Dto  
enumNameSuffix=Enum  

Clean output before regeneration.

---

## Output Standard

When invoked, I:

• Analyze controller decorators  
• Detect enum duplication risk  
• Recommend refactor patches  
• Validate OpenAPI JSON structure  
• Provide stable generator command  

My output is deterministic and enterprise-ready.

