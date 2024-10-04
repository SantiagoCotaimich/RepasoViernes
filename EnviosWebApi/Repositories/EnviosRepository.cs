using EnviosWebApi.Models;

namespace EnviosWebApi.Repositories
{
    public class EnviosRepository : IEnviosRepository
    {

        private EnviosContext _context;

        public EnviosRepository(EnviosContext context)
        {
            _context = context;
        }


        public TEnvio? GetById(int id)
        {
            return _context.TEnvios.Find(id);
        }


        public bool Create(TEnvio envio)
        {
            _context.TEnvios.Add(envio);
            return _context.SaveChanges() == 1;
        }

        public bool Delete(int id)
        {
            var envio = GetById(id);
            if (envio != null)
            {

                envio.Estado = "Eliminado"; 

                _context.TEnvios.Update(envio);
                _context.SaveChanges();

                return true;
            }
            else
            {
                return false;
            }
        }

        public List<TEnvio> GetByDates(DateTime? fechaInicio, DateTime? fechaFin)
        {
            var query = _context.TEnvios.AsQueryable();

            if (fechaInicio.HasValue)
            {
                query = query.Where(e => e.FechaEnvio >= fechaInicio.Value);
            }

            if (fechaFin.HasValue)
            {
                query = query.Where(e => e.FechaEnvio <= fechaFin.Value);
            }

            return query.ToList();
        }
    }
}
