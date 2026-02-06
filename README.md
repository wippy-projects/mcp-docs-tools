# Wippy Documentation Tools

MCP tools for searching and reading the [Wippy documentation](https://home.wj.wippy.ai/) directly
from an LLM client. Backed by the Wippy docs LLM API — search, browse, read pages, and traverse
related content without leaving the conversation.

## Dependency

Requires [`butschster/mcp-server`](../mcp/) — the MCP server that discovers and exposes these tools.

```yaml
# wippy.yaml
organization: butschster
module: docs-tools
```

## Tools

| Tool | Endpoint | Description |
|------|----------|-------------|
| `wippy_docs_search` | `/llm/search?q=` | Full-text search across all 93 doc pages. Returns chunk IDs, paths, scores, and summaries. |
| `wippy_docs_read` | `/llm/path/en/` | Read full page content by path. Supports comma-separated batch fetch and `summary=true` mode. |
| `wippy_docs_toc` | `/llm/toc` | Get the complete table of contents as JSON. |
| `wippy_docs_lookup` | `/llm/chunk/` | Get a specific chunk by ID, or find related content with `related=true`. |

## Typical Workflow

1. **Browse** — call `wippy_docs_toc` to see all available pages
2. **Search** — call `wippy_docs_search` with a query to find relevant chunks
3. **Read** — call `wippy_docs_read` with a path from the TOC or search results
4. **Dive deeper** — call `wippy_docs_lookup` with a chunk ID to get related topics

### Examples

Search for HTTP routing:
```
wippy_docs_search(query="http routing middleware")
```

Read a page:
```
wippy_docs_read(path="lua/http/client")
```

Batch read multiple pages:
```
wippy_docs_read(path="lua/core/process,lua/core/channel")
```

Get a summary instead of full content:
```
wippy_docs_read(path="guides/configuration", summary=true)
```

Look up a chunk from search results:
```
wippy_docs_lookup(id="http/router#routing")
```

Find related content:
```
wippy_docs_lookup(id="http/router#routing", related=true)
```

## Architecture

```
docs_tools/
├── _index.yaml        Tool entries + MCP server dependency
├── wippy.yaml         Module metadata
├── docs_search.lua    Tool: search docs
├── docs_read.lua      Tool: read pages (single, batch, summary)
├── docs_toc.lua       Tool: table of contents
├── docs_lookup.lua    Tool: chunk lookup + related content
└── README.md
```

All tools use the `http_client` module to call the Wippy docs LLM API at
`https://home.wj.wippy.ai/llm/`.
